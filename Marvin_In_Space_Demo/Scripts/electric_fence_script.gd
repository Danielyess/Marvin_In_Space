#This Scene shold be put into a PowerGrid if you want to use it with the intention
# of activating and deactivating it

#For information about Emitters see: power_grid.gd

extends StaticBody2D

@export var currentState : Pwr.PowerState = Pwr.PowerState.ON

var canGiveJump : bool = true

func _ready() -> void:
	switchState(currentState, true)

func switchState(desired_state : Pwr.PowerState, force : bool)  -> void:
	if currentState != desired_state or force:
		match desired_state:
			Pwr.PowerState.ON: 
				switchOn()
			Pwr.PowerState.OFF:
				switchOff()
			_:
				printerr("Desired state does not exist!")

func switchOn() -> void:
	currentState = Pwr.PowerState.ON
	$PostSprite.play("Active")
	$EffectSprite.play("Active")
	$EffectSprite.visible = true
	$HitBox2D/HitBoxCollShape.set_deferred("disabled", false)
	$ScrewDriverInteractionArea/SDInteractionCollShape.set_deferred("disabled", false)

func switchOff() -> void:
	currentState = Pwr.PowerState.OFF
	$PostSprite.play("Inactive")
	$EffectSprite.pause()
	$EffectSprite.visible = false
	$HitBox2D/HitBoxCollShape.set_deferred("disabled", true)
	$ScrewDriverInteractionArea/SDInteractionCollShape.set_deferred("disabled", true)
