class_name PowerLine2D
extends Line2D

var current_state : Pwr.PowerState
var red : Color
var green : Color

@export var emitter : StaticBody2D
@export var reciever : StaticBody2D

func _init() -> void:
	red = Color(255,0,0,0.5)
	green = Color(0,255,0,0.5)

func _ready() -> void:
	switchState(Pwr.PowerState.OFF)

func switchState(desiredState : Pwr.PowerState) -> void:
	if desiredState != current_state:
		match desiredState:
			Pwr.PowerState.OFF:
				current_state = Pwr.PowerState.OFF
				self.default_color = red
			Pwr.PowerState.ON:
				current_state = Pwr.PowerState.ON
				self.default_color = green
			_:
				printerr("PowerState does not exist!")
		reciever.switchState(current_state)
