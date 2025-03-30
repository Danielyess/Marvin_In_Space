extends StaticBody2D

@export var current_state : Pwr.PowerState = Pwr.PowerState.ON

func _ready() -> void:
	switchState(current_state, true)

func switchState(desired_state : Pwr.PowerState, force : bool)  -> void:
	if current_state != desired_state or force:
		match desired_state:
			Pwr.PowerState.ON: 
				current_state = Pwr.PowerState.ON
				$PostSprite.play("Active")
				$EffectSprite.play("Active")
				$EffectSprite.visible = true
				$HitBox/CollisionShape2D.disabled = false
				$ScrewDriverArea/CollisionShape2D.disabled = false
			Pwr.PowerState.OFF:
				current_state = Pwr.PowerState.OFF
				$PostSprite.play("Inactive")
				$EffectSprite.pause()
				$EffectSprite.visible = false
				$HitBox/CollisionShape2D.disabled = true
				$ScrewDriverArea/CollisionShape2D.disabled = true
