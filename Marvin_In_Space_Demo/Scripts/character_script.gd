extends CharacterBody2D

@export var speedChange : float = 15;
@export var gravity : float = 10; # 1g
@export var jumpForce : float = 200;
@export var dashStrength : float = 200;
@export var jumpCharges : int = 2;
#i want to rename ts
@export var slowerVariable : float = 10
@export var speedCap : float = 300


var ScrewDriver : CharacterBody2D
var Marker_Right : Marker2D
var Marker_Left : Marker2D
var Animation_Handler : AnimatedSprite2D

func _physics_process(_delta : float):
	
	var horizontalDirection : float = Input.get_axis("MoveLeft","MoveRight");
	movementHandlerFunc(horizontalDirection)
	
	if(!is_on_floor()):
		velocity.y += gravity;
	else:
		velocity.y = 0;
		jumpCharges = 2;
	
	if(Input.is_action_just_pressed("Jump") && jumpCharges > 0):
		velocity.y = -jumpForce;
		Animation_Handler.play("Jump")
		jumpCharges-=1;
	
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
	ScrewDriver = get_node("ScrewDriver")
	Marker_Left = get_node("ScrewDriverPosition_Left")
	Marker_Right = get_node("ScrewDriverPosition_Right")
	Animation_Handler = get_node("SpriteAnimation")
	
	pass; # Replace with function body.aaaaa


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
	
	print_debug("Hit")
	
	pass;
