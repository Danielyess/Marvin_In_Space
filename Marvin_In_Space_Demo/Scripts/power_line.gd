class_name PowerLine2D
extends Line2D

enum State{On, Off}
var isPowered : bool
var red : Color
var green : Color

func _init() -> void:
	red = Color(255,0,0,1)
	green = Color(0,255,0,1)

func _ready() -> void:
	switchState(State.Off)

func switchState(state : State) -> void:
	if state == State.Off:
		self.default_color = red
		isPowered = false
	elif state == State.On:
		self.default_color = green
		isPowered = true
	else:
		printerr("State does not exist!")
