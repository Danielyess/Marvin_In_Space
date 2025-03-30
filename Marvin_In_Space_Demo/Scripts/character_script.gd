extends CharacterBody2D

@export var speedChange : float = 15;
@export var gravity : float = 600; # 1g
@export var jumpForce : float = 320;
@export var dashStrength : float = 100;
@export var jumpCharges : int = 2;
@export var slowerVariable : float = 10
@export var speedCap : float = 300

var interactions := []
var canInteract : bool = true
var canGetJump : bool = true

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
				print_debug("Tried to interact with " + interactions[0].owner.name)
	
	if event.is_action_pressed("Down"):
		self.collision_layer = 0b1
		self.collision_mask = 0b1
	if event.is_action_released("Down"):
		self.collision_layer = 0b10001
		self.collision_mask = 0b10001


func _physics_process(_delta : float):
	var horizontalDirection : float = Input.get_axis("MoveLeft","MoveRight");
	movementHandlerFunc(horizontalDirection)
	if(!is_on_floor()):
		velocity.y += gravity / 60;
	else:
		velocity.y = 0;
		jumpCharges = 2
		canGetJump = true
	
	if(Input.is_action_just_pressed("Jump") && jumpCharges > 0):
		velocity.y = -jumpForce;
		Animation_Handler.play("Jump")
		jumpCharges-=1
	
	if(Input.is_action_just_pressed("Dash")):
		if(horizontalDirection >= 0):
			position.x += dashStrength;
		else:
			position.x -= dashStrength;
	
	
	screwDriverFunc()
	
	move_and_slide()
	pass; 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass; # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass;


func screwDriverFunc() -> void:
	if get_local_mouse_position().x < 0 or velocity.x < 0 :
		ScrewDriver.position.x = Marker_Left.position.x
		ScrewDriver.position.y = Marker_Left.position.y
	else:
		ScrewDriver.position.x = Marker_Right.position.x
		ScrewDriver.position.y = Marker_Right.position.y



func movementHandlerFunc(horizontalDirection: float) -> void:
	if horizontalDirection != 0: 
		velocity.x += speedChange * horizontalDirection;
		if is_on_floor() and Animation_Handler.animation != "Jump":
			Animation_Handler.play("Run")
		elif Animation_Handler.animation != "Jump":
			Animation_Handler.play("Look")
			
		if horizontalDirection > 0 :
			Animation_Handler.flip_h = 0
		else:
			Animation_Handler.flip_h = 1
	else:
		velocity.x -= slowerVariable * sign(velocity.x)
		Animation_Handler.play("Idle")
	
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
	if jumpCharges > 2:
		jumpCharges = 2
