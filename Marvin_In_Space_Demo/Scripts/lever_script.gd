#This Scene should be placed into a PowerGrid2D, which is subtype of a Node2D
#Should be put into the Node Emitters in the PowerGrid2D

#For information about Emitters see: power_grid.gd
extends StaticBody2D

@export var currentState : Pwr.PowerState = Pwr.PowerState.OFF

signal stateChanged(emitter : StaticBody2D)

@onready var InteractionSprite : Sprite2D = $InteractionSprite
@onready var SpriteAnimation : AnimatedSprite2D =  $MainSprite  

var defaultState : Pwr.PowerState

func _ready() -> void:
	switchState(currentState,true)
	defaultState = currentState
	if currentState == Pwr.PowerState.ON:
		SpriteAnimation.play("DefaultON")
	else:
		SpriteAnimation.play("DefaultOFF")
	
	$BaseCollShape.disabled = true
	InteractionSprite.visible = false
	InteractionSprite.scale = self.scale * 0.5
	InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2
	InteractionSprite.rotation = -self.rotation
	# This is connected to a powerGrid's refreshGrid function
	connect("stateChanged", $"../..".refreshGrid)

func showInteract() -> void:
	InteractionSprite.visible = true

func hideInteract() -> void:
	InteractionSprite.visible = false

func interact() -> void:
	if currentState == Pwr.PowerState.ON:
		switchState(Pwr.PowerState.OFF,false)
	else:
		switchState(Pwr.PowerState.ON,false)

func switchState(desired_state : Pwr.PowerState, force : bool) -> void:
	if currentState != desired_state or force:
		match(desired_state):
			Pwr.PowerState.ON:
				switchOn()
			Pwr.PowerState.OFF: 
				switchOff()
		emit_signal("stateChanged", self)

func switchOn() -> void:
	SpriteAnimation.play("On")
	currentState = Pwr.PowerState.ON

func switchOff() -> void:
	SpriteAnimation.play("Off")
	currentState = Pwr.PowerState.OFF

func resetState():
	switchState(defaultState, true)
