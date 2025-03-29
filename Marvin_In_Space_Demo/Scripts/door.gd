extends StaticBody2D

var current_state : Pwr.PowerState

func _ready() -> void:
	current_state = Pwr.PowerState.OFF
	$MainSprite.play("Default")
	pass;
	


func switchState(desiredState : Pwr.PowerState) -> void:
	if current_state != desiredState:
		match desiredState:
			Pwr.PowerState.ON:
				current_state = Pwr.PowerState.ON
				self.collision_layer = 0b0
				$MainSprite.play("Opening")
			Pwr.PowerState.OFF:
				current_state = Pwr.PowerState.OFF
				self.collision_layer = 0b1
				$MainSprite.play("Closing")
