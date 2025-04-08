extends StaticBody2D

enum SubroutinePreset{ #Check switchBoxPresets OneNote for reference
	None = 0,
	One = 1,
	TwoZeroZero = 2,
	TwoZeroOne = 3,
	TwoOneZero = 4,
	ThreeBaseZero = 5,
	ThreeBaseOne = 6,
	ThreeSpecialZero = 7,
	ThreeSpecialOne = 8,
	ThreeSpecialTwo = 9
}

enum LogicGate{
	None,
	Buffer,
	Not,
	Or,
	And,
	NAnd,
	NOr,
	XOr
}

@export var Subroutine : SubroutinePreset = SubroutinePreset.None
@export var Gate0 : LogicGate = LogicGate.None
@export var Gate1 : LogicGate = LogicGate.None
@export var Gate2 : LogicGate = LogicGate.None
@export var Gate3 : LogicGate = LogicGate.None

@export var Wire0 : PowerLine2D
@export var Wire1 : PowerLine2D
@export var Wire2 : PowerLine2D

var currentState : Pwr.PowerState = Pwr.PowerState.OFF

var isOpen : bool
var cover : RigidBody2D
var canGiveJump : bool = false

signal stateChanged(emitter : StaticBody2D)

func _ready() -> void:
	$MainSprite.play("Locked")
	$InteractionSprite.visible = false
	$InteractionSprite.scale = Vector2(0.5,0.5)
	$InteractionSprite.position.y -= 30 * (self.scale.x + self.scale.y) /2
	$BaseCollShape.disabled = true
	isOpen = false
	connect("stateChanged", $"../..".refreshGrid)
	
	cover = load("res://Scenes/switch_box_cover.tscn").instantiate()

func showInteract() -> void:
	if isOpen:
		$InteractionSprite.visible = true

func hideInteract() -> void:
	if isOpen:
		$InteractionSprite.visible = false

func interact() -> void:
	if isOpen:
		var menu : Control = load("res://Scenes/switch_box_menu.tscn").instantiate()
		menu.process_mode = Node.PROCESS_MODE_ALWAYS
		menu.loadGraphic(Subroutine, Gate0, Gate1, Gate2, Gate3)
		menu.scale.x = 1/get_viewport().get_camera_2d().zoom.x
		menu.scale.y = 1/get_viewport().get_camera_2d().zoom.y
		if get_viewport().get_camera_2d().owner.position.x <= 0 :
			menu.position = get_viewport().get_camera_2d().position
		else:
			menu.position = get_viewport().get_camera_2d().owner.position
		add_child(menu)
		get_tree().paused = true


func openBox() -> void:
	if !isOpen:
		$MainSprite.play("Open")
		isOpen = true
		$InteractionSprite.visible = true
		add_child(cover)
		$CoverTimeoutTimer.start()

func startOpeningTimer() -> void:
	$openingTimer.start()


func _on_opening_timer_timeout() -> void:
	openBox()

func startTimer():
	if not $openingTimer.paused:
		$openingTimer.start()
	else:
		$openingTimer.paused = false

func pauseTimer():
	$openingTimer.paused = true

func _on_cover_timeout_timer_timeout() -> void:
	cover.queue_free()

func startSubroutine() -> void: 
	var subGateVal : Pwr.PowerState = Pwr.PowerState.OFF
	var subGateVal2 : Pwr.PowerState = Pwr.PowerState.OFF
	var subGateVal3 : Pwr.PowerState = Pwr.PowerState.OFF
	
	match(Subroutine):
		SubroutinePreset.None:
			pass;
		SubroutinePreset.One:
			currentState = callGateFunc(Gate0, Wire0.currentState)
			
		SubroutinePreset.TwoZeroZero: #Both wires go into one 2-input logic gate
			currentState = callGateFunc(Gate0, Wire0.currentState, Wire1.currentState)
			
		SubroutinePreset.TwoZeroOne: #The Left Wire goes into a 1-input logic gate, then both into a 2-input
			subGateVal = callGateFunc(Gate1, Wire1.currentState)
			currentState = callGateFunc(Gate0, subGateVal, Wire0.currentState)
			
		SubroutinePreset.TwoOneZero: #The Right Wire goes into a 1-input logic gate, then both into a 2-input
			subGateVal = callGateFunc(Gate1, Wire0.currentState)
			currentState = callGateFunc(Gate0, Wire1.currentState, subGateVal)
			
		SubroutinePreset.ThreeBaseZero: #The Left and the Middle wires go into a 2-input gate and then the result plus the Right go into another 2-input gate 
			subGateVal = callGateFunc(Gate1, Wire0.currentState, Wire1.currentState)
			currentState = callGateFunc(Gate0, subGateVal, Wire2.currentState)
			
		SubroutinePreset.ThreeBaseOne: #The Left and the Middle wires go into a 2-input gate and then the result plus the Right goes into a 1-input gate then they go into another 2-input gate 
			subGateVal = callGateFunc(Gate1, Wire0.currentState, Wire1.currentState)
			subGateVal2 = callGateFunc(Gate2, Wire2.currentState)
			currentState = callGateFunc(Gate0, subGateVal, subGateVal2)
			
		SubroutinePreset.ThreeSpecialZero:
			subGateVal = callGateFunc(Gate1, Wire0.currentState, Wire1.currentState)
			subGateVal2 = callGateFunc(Gate2, Wire1.currentState, Wire2.currentState)
			currentState = callGateFunc(Gate0, subGateVal, subGateVal2)
			
		SubroutinePreset.ThreeSpecialOne:
			subGateVal3 = callGateFunc(Gate3, Wire1.currentState)
			subGateVal = callGateFunc(Gate1, Wire0.currentState, subGateVal3)
			subGateVal2 = callGateFunc(Gate2, Wire1.currentState, Wire2.currentState)
			currentState = callGateFunc(Gate0, subGateVal, subGateVal2)
			
		SubroutinePreset.ThreeSpecialTwo:
			subGateVal3 = callGateFunc(Gate3, Wire1.currentState, Wire2.currentState)
			subGateVal = callGateFunc(Gate1, Wire0.currentState, Wire1.currentState)
			subGateVal2 = callGateFunc(Gate2, subGateVal3, Wire2.currentState)
			currentState = callGateFunc(Gate0, subGateVal, subGateVal2)
			
		_:
			printerr("SUBROUTINE DOESNT EXIST!!!!!!")
	emit_signal("stateChanged", self)

func callGateFunc(gate : LogicGate, state1 : Pwr.PowerState, state2: Pwr.PowerState = Pwr.PowerState.OFF) -> Pwr.PowerState:
	match(gate):
		LogicGate.Buffer:
			return Pwr.BUFFER(state1)
			
		LogicGate.Not:
			return Pwr.NOT(state1)
			
		LogicGate.Or:
			return Pwr.OR(state1, state2)
			
		LogicGate.And:
			return Pwr.AND(state1, state2)
			
		LogicGate.NAnd:
			return Pwr.NAND(state1, state2)
			
		LogicGate.NOr:
			return Pwr.NOR(state1, state2)
			
		LogicGate.XOr:
			return Pwr.XOR(state1, state2)
			
	return Pwr.PowerState.OFF

func switchState(_desiredState : Pwr.PowerState, _force : bool) ->void:
	startSubroutine()
