#This Scene shold be put into a PowerGrid if you want to use it with the intention
# of opening and closing it

#In the PowerGrid it should be put into the Recievers Node

#For information about Emitters see: power_grid.gd
extends StaticBody2D

@export var currentState : Pwr.PowerState = Pwr.PowerState.OFF

@onready var InteractionSprite : Sprite2D = $InteractionSprite
@onready var SpriteAnimation : AnimatedSprite2D =  $MainSprite  

func _ready() -> void:
	InteractionSprite.visible = false
	InteractionSprite.scale = self.scale * 0.5
	InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2
	InteractionSprite.position.x = 0
	$InteractionArea2D/InteractionCollShape.set_deferred("disabled", true)
	switchState(currentState, true)
	if currentState == Pwr.PowerState.ON:
		SpriteAnimation.play("DefaultON")
	else:
		SpriteAnimation.play("DefaultOFF")

func showInteract() -> void:
	InteractionSprite.visible = true	

func hideInteract() -> void:
	InteractionSprite.visible = false

func interact() -> void:
	if owner.get_parent().has_method("nextLevel"):
		owner.get_parent().nextLevel()

func switchState(desiredState : Pwr.PowerState, force : bool) -> void:
	if currentState != desiredState or force:
		match desiredState:
			Pwr.PowerState.ON:
				switchOn()
			Pwr.PowerState.OFF:
				switchOff()
			_:
				printerr("Desired state does not exist!")

func switchOn() -> void:
	SpriteAnimation.play("Opening")
	$InteractionArea2D/InteractionCollShape.set_deferred("disabled", false)
	currentState = Pwr.PowerState.ON

func switchOff() -> void:
	SpriteAnimation.play("Closing")
	$InteractionArea2D/InteractionCollShape.set_deferred("disabled", true)
	currentState = Pwr.PowerState.OFF
