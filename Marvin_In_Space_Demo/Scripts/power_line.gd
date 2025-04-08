#This node is used to transport powerstate between and emitter and a reciever
#Should also be used if you want to attach the output of a switchbox to one of its ports

class_name PowerLine2D
extends Line2D

var currentState : Pwr.PowerState

@export var emitter : StaticBody2D
@export var reciever : StaticBody2D

func _init() -> void:
	width = 2
	z_index = 2

func _ready() -> void:
	#Forces the emitter's state onto the wire so that it updates when the map is 
	#loaded so its not needed to be done in the editor by hand
	switchState(emitter.currentState, true)

func switchState(desiredState : Pwr.PowerState, force : bool) -> void:
	if desiredState != currentState or force:
		match desiredState:
			Pwr.PowerState.OFF:
				currentState = Pwr.PowerState.OFF
				#if the wire carries an off signal then be red
				self.default_color = Color(255,0,0,0.5)
			Pwr.PowerState.ON:
				currentState = Pwr.PowerState.ON
				#if the wire carries an on signal then be green
				self.default_color = Color(0,255,0,0.5)
			_:
				printerr("PowerState does not exist!")
		#Switches it's reciever's powerstate if it is not already
		reciever.switchState(currentState, false)
