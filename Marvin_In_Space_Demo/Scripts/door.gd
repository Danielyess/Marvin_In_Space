extends StaticBody2D

@export var current_state : Pwr.PowerState = Pwr.PowerState.OFF

func _ready() -> void:
	switchState(current_state, true)
	if current_state == Pwr.PowerState.ON:
		$MainSprite.play("DefaultON")
	else:
		$MainSprite.play("DefaultOFF")
	pass;
	


func switchState(desiredState : Pwr.PowerState, force : bool) -> void:
	if current_state != desiredState or force:
		match desiredState:
			Pwr.PowerState.ON:
				current_state = Pwr.PowerState.ON
				self.collision_layer = 0b0
				$MainSprite.play("Opening")
			Pwr.PowerState.OFF:
				current_state = Pwr.PowerState.OFF
				self.collision_layer = 0b1
				$MainSprite.play("Closing")
