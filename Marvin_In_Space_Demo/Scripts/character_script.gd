extends CharacterBody2D

#How much the character will accelerate in given direction
#If no inputs are given to the character it will be slowed by speedSlow to the point it is still
@export var speedChange : float = 15
@export var speedSlow : float = 10
@export var speedCap : float = 300

#/60 because of the _physics_process
@export var gravity : float = 600 # 1g 

#How much velocity will the character jump
@export var jumpForce : float = 320
@export var maxJumpCharges : int = 2
var canGetJump : bool = true
var jumpCharges : int = 2;

#How far he can teleport
@export var teleportLength : float = 100
@export var canTeleport : bool = true
var teleportCharge : int = 1;

enum AnimationState{Jump, Run, Idle, Teleport}
var currentState : AnimationState

var interactions := []
var canInteract : bool = true


@onready var ScrewDriver : CharacterBody2D = $ScrewDriver
@onready var MarkerRight : Marker2D = $ScrewDriverPosition_Right
@onready var MarkerLeft : Marker2D = $ScrewDriverPosition_Left
@onready var SpriteAnimation : AnimatedSprite2D = $SpriteAnimation

@onready var JetpackIcons :=  [$JetpackIcon1, $JetpackIcon2]
@onready var TeleportIcon : Sprite2D = $TeleportIcon
@onready var TeleportFeeler : Area2D = $TeleportArea

func _ready() -> void:
	JetpackIcons[0].scale = self.scale * 0.5
	JetpackIcons[0].position.x = -5
	JetpackIcons[0].position.y = -25
	JetpackIcons[1].scale = self.scale * 0.5
	JetpackIcons[1].position.x = 5
	JetpackIcons[1].position.y = -25
	TeleportIcon.position.x = self.position.x
	TeleportIcon.position.y = -40
	TeleportIcon.scale = self.scale * 0.5
	TeleportFeeler.position.y = 0
	TeleportFeeler.collision_layer = 0
	TeleportFeeler.collision_mask = 0b10001

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and canInteract:
			if interactions:
				canInteract = false
				await interactions[0].interact.call()
				canInteract = true
	
	#This is for the platform, it turns off the collision layer that would be on the platform and it falls through it
	if event.is_action_pressed("Down"):
		self.collision_layer = 0b1
		self.collision_mask = 0b1
	if event.is_action_released("Down"):
		self.collision_layer = 0b10001
		self.collision_mask = 0b10001
	
	#When the character gets stuck or just is stuck
	if event.is_action_pressed("Explode"):
		self.takeDamage()

func _physics_process(_delta : float):
	var horizontalDirection : float = Input.get_axis("MoveLeft","MoveRight");
	MovementHandler(horizontalDirection)
	AnimationHandler(horizontalDirection)
	TeleportFeeler.position.x = teleportLength * sign(horizontalDirection+0.1)
	if !is_on_floor():
		velocity.y += gravity / 60;
	else:
		velocity.y = 0;
		jumpCharges = maxJumpCharges
		teleportCharge = 1
		if maxJumpCharges > 1:
			canGetJump = true
		updateJumpChargeSprite()
		updateTeleportSprite()
	
	if(Input.is_action_just_pressed("Jump") && jumpCharges > 0):
		if (maxJumpCharges == 1 and is_on_floor()) or maxJumpCharges > 1:
			velocity.y = -jumpForce;
		if maxJumpCharges > 1:
			SpriteAnimation.play("Jump")
		jumpCharges -= 1
		updateJumpChargeSprite()
		currentState = AnimationState.Jump
	
	if(Input.is_action_just_pressed("Teleport") and canTeleport and teleportCharge > 0 and TeleportFeeler.get_overlapping_bodies().is_empty()):
		position.x += teleportLength * sign(horizontalDirection+0.1);
		self.velocity.y = 0
		SpriteAnimation.play("Teleport")
		currentState = AnimationState.Teleport
		teleportCharge -= 1
		updateTeleportSprite()
	
	
	screwDriverFunc(horizontalDirection)
	move_and_slide() 

func _process(_delta: float) -> void:
	pass;

func screwDriverFunc(horizontalDirection : float) -> void:
	if horizontalDirection < 0:
			ScrewDriver.position.x = MarkerLeft.position.x
			ScrewDriver.position.y = MarkerLeft.position.y
	elif horizontalDirection > 0:
			ScrewDriver.position.x = MarkerRight.position.x
			ScrewDriver.position.y = MarkerRight.position.y
	else:
		if get_local_mouse_position().x > 0 :
			ScrewDriver.position.x = MarkerRight.position.x
			ScrewDriver.position.y = MarkerRight.position.y
		else:
			ScrewDriver.position.x = MarkerLeft.position.x
			ScrewDriver.position.y = MarkerLeft.position.y

func MovementHandler(horizontalDirection: float) -> void:
	if horizontalDirection != 0: 
		velocity.x += speedChange * horizontalDirection;
	else:
		velocity.x -= speedSlow * sign(velocity.x)
	
	if abs(velocity.x) > speedCap :
		velocity.x -= (abs(velocity.x) - speedCap) * 0.33 * sign(velocity.x)
		pass; 
	
	if abs(velocity.x) < speedSlow:
		velocity.x = 0

func AnimationHandler(horizontalDirection : float) -> void:
	if horizontalDirection != 0:
		if is_on_floor() and currentState != AnimationState.Jump and currentState != AnimationState.Teleport:
			if maxJumpCharges > 1:
				SpriteAnimation.play("Run")
			else:
				SpriteAnimation.play("Run_NoJetpack")
			currentState = AnimationState.Run
		elif currentState != AnimationState.Jump and currentState != AnimationState.Teleport:
			if maxJumpCharges > 1:
				SpriteAnimation.play("Look")
			else:
				SpriteAnimation.play("Look_NoJetpack")
			currentState = AnimationState.Run
			
		if horizontalDirection > 0 :
			SpriteAnimation.flip_h = 0
		else:
			SpriteAnimation.flip_h = 1
	else:
		SpriteAnimation.play("Idle")
		currentState = AnimationState.Idle

func takeDamage() -> void:
	if get_parent().has_method("deathAnimation"):
		get_parent().deathAnimation()
		
	if get_parent().has_method("restartMap"):
		get_parent().call_deferred("restartMap")
		
	if get_parent().has_method("deathAnimationRev"):
		get_parent().deathAnimationRev()

func AddInteractable(area : Area2D):
	interactions.push_back(area)

func RemoveInteractable(area : Area2D):
	interactions.erase(area)

func multGravity(gravMult):
	gravity *= gravMult

func addJumpCharge(num : int , force: bool) -> void:
	if canGetJump or force:
		jumpCharges += num
		if jumpCharges > maxJumpCharges:
			jumpCharges = maxJumpCharges
		if !force:
			canGetJump = false
		updateJumpChargeSprite()

func updateJumpChargeSprite() -> void:
	if maxJumpCharges > 1:
		JetpackIcons[0].visible = true
		JetpackIcons[1].visible = true
		if jumpCharges == 2:
			JetpackIcons[0].self_modulate = Color(1,1,1,1)
			JetpackIcons[1].self_modulate = Color(1,1,1,1)
		elif jumpCharges == 1:
			JetpackIcons[0].self_modulate = Color(1,1,1,1)
			JetpackIcons[1].self_modulate = Color(1,1,1,0.4)
		else:
			JetpackIcons[0].self_modulate = Color(1,1,1,0.4)
			JetpackIcons[1].self_modulate = Color(1,1,1,0.4)
	else:
		JetpackIcons[0].visible = false
		JetpackIcons[1].visible = false

func updateTeleportSprite() -> void:
	if canTeleport:
		TeleportIcon.visible = true
		if teleportCharge > 0:
			TeleportIcon.self_modulate = Color(1,1,1,1)
		else:
			TeleportIcon.self_modulate = Color(1,1,1,0.4)
	else:
		$TeleportIcon.visible = false
