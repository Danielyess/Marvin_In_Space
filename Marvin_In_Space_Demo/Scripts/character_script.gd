extends CharacterBody2D

@export var speedChange : float = 15;
@export var gravity : float = 600; # 1g
@export var jumpForce : float = 320;
@export var dashStrength : float = 100;
@export var slowerVariable : float = 10
@export var speedCap : float = 300
@export var maxJumpCharges : int = 2
@export var canDash : bool = true

enum AnimationState{Jump, Run, Idle, Dash}

var interactions := []
var canInteract : bool = true
var canGetJump : bool = true
var jumpCharges : int = 2;
var dashCharge : int = 1;
var current_state : AnimationState

@onready var ScrewDriver : CharacterBody2D = $ScrewDriver
@onready var Marker_Right : Marker2D = $ScrewDriverPosition_Right
@onready var Marker_Left : Marker2D = $ScrewDriverPosition_Left
@onready var Animation_Handler : AnimatedSprite2D = $SpriteAnimation

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and canInteract:
			if interactions:
				canInteract = false
				await interactions[0].interact.call()
				canInteract = true
	
	if event.is_action_pressed("Down"):
		self.collision_layer = 0b1
		self.collision_mask = 0b1
	if event.is_action_released("Down"):
		self.collision_layer = 0b10001
		self.collision_mask = 0b10001
	
	if event.is_action("Explode"):
		self.takeDamage()

func _physics_process(_delta : float):
	var horizontalDirection : float = Input.get_axis("MoveLeft","MoveRight");
	movementHandlerFunc(horizontalDirection)
	if(!is_on_floor()):
		velocity.y += gravity / 60;
	else:
		velocity.y = 0;
		jumpCharges = maxJumpCharges
		dashCharge = 1
		if maxJumpCharges > 1:
			canGetJump = true
		updateJumpChargeSprite()
		updateDashSprite()
	
	if(Input.is_action_just_pressed("Jump") && jumpCharges > 0):
		velocity.y = -jumpForce;
		if maxJumpCharges > 1:
			Animation_Handler.play("Jump")
		jumpCharges -= 1
		updateJumpChargeSprite()
		current_state = AnimationState.Jump
	
	if(Input.is_action_just_pressed("Dash") and canDash):
		if(horizontalDirection >= 0):
			position.x += dashStrength;
		else:
			position.x -= dashStrength;
		Animation_Handler.play("Teleport")
		current_state = AnimationState.Dash
		dashCharge -= 1
		updateDashSprite()
	
	
	screwDriverFunc(horizontalDirection)
	move_and_slide()
	pass; 

func _ready() -> void:
	$JetpackIcon1.scale = self.scale * 0.5
	$JetpackIcon1.position.x = -5
	$JetpackIcon1.position.y = -25
	$JetpackIcon2.scale = self.scale * 0.5
	$JetpackIcon2.position.x = 5
	$JetpackIcon2.position.y = -25
	$DashIcon.position.x = self.position.x
	$DashIcon.position.y = -40
	$DashIcon.scale = self.scale * 0.5
	pass; # Replace with function body.

func _process(_delta: float) -> void:
	pass;

func screwDriverFunc(horizontalDirection : float) -> void:
	if horizontalDirection < 0:
			ScrewDriver.position.x = Marker_Left.position.x
			ScrewDriver.position.y = Marker_Left.position.y
	elif horizontalDirection > 0:
			ScrewDriver.position.x = Marker_Right.position.x
			ScrewDriver.position.y = Marker_Right.position.y
	else:
		if get_local_mouse_position().x > 0 :
			ScrewDriver.position.x = Marker_Right.position.x
			ScrewDriver.position.y = Marker_Right.position.y
		else:
			ScrewDriver.position.x = Marker_Left.position.x
			ScrewDriver.position.y = Marker_Left.position.y

func movementHandlerFunc(horizontalDirection: float) -> void:
	if horizontalDirection != 0: 
		velocity.x += speedChange * horizontalDirection;
		if is_on_floor() and current_state != AnimationState.Jump and current_state != AnimationState.Dash:
			if maxJumpCharges > 1:
				Animation_Handler.play("Run")
			else:
				Animation_Handler.play("Run_NoJetpack")
			current_state = AnimationState.Run
		elif current_state != AnimationState.Jump and current_state != AnimationState.Dash:
			if maxJumpCharges > 1:
				Animation_Handler.play("Look")
			else:
				Animation_Handler.play("Look_NoJetpack")
			current_state = AnimationState.Run
			
		if horizontalDirection > 0 :
			Animation_Handler.flip_h = 0
		else:
			Animation_Handler.flip_h = 1
	else:
		velocity.x -= slowerVariable * sign(velocity.x)
		Animation_Handler.play("Idle")
		current_state = AnimationState.Idle
	
	if abs(velocity.x) > speedCap :
		velocity.x -= (abs(velocity.x) - speedCap) * 0.33 * sign(velocity.x)
		pass; 
	
	if abs(velocity.x) < slowerVariable:
		velocity.x = 0
	
	pass;

func takeDamage() -> void:
	if get_parent().has_method("deathAnimation"):
		get_parent().deathAnimation()
	
	if get_parent().has_method("resetCharacterPosition"):
		get_parent().resetCharacterPosition()
	
	if get_parent().has_method("deathAnimationRev"):
		get_parent().deathAnimationRev()

func addInteractable(area : Area2D):
	interactions.push_back(area)

func removeInteractable(area : Area2D):
	interactions.erase(area)

func multGravity(gravMult):
	gravity *= gravMult

func addJumpCharge(num : int) -> void:
	if canGetJump:
		jumpCharges += num
		canGetJump = false
		updateJumpChargeSprite()
	if jumpCharges > maxJumpCharges:
		jumpCharges = maxJumpCharges

func updateJumpChargeSprite() -> void:
	if maxJumpCharges > 1:
		$JetpackIcon1.visible = true
		$JetpackIcon2.visible = true
		if jumpCharges == 2:
			$JetpackIcon1.self_modulate = Color(1,1,1,1)
			$JetpackIcon2.self_modulate = Color(1,1,1,1)
		elif jumpCharges == 1:
			$JetpackIcon1.self_modulate = Color(1,1,1,1)
			$JetpackIcon2.self_modulate = Color(1,1,1,0.4)
		else:
			$JetpackIcon1.self_modulate = Color(1,1,1,0.4)
			$JetpackIcon2.self_modulate = Color(1,1,1,0.4)
	else:
		$JetpackIcon1.visible = false
		$JetpackIcon2.visible = false

func updateDashSprite() -> void:
	if canDash:
		$DashIcon.visible = true
		if dashCharge > 0:
			$DashIcon.self_modulate = Color(1,1,1,1)
		else:
			$DashIcon.self_modulate = Color(1,1,1,0.4)
	else:
		$DashIcon.visible = false
