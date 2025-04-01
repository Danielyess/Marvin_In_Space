extends StaticBody2D

@export var current_state : Pwr.PowerState = Pwr.PowerState.OFF

func _ready() -> void:
	$BaseCollShape.disabled = true
	$InteractionSprite.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2
	$InteractionSprite.position.x = 0
	$InteractionArea2D/CollisionShape2D.disabled = true
	switchState(current_state, true)
	if current_state == Pwr.PowerState.ON:
		$MainSprite.play("DefaultON")
	else:
		$MainSprite.play("DefaultOFF")

func showInteract() -> void:
	$InteractionSprite.visible = true	

func hideInteract() -> void:
	$InteractionSprite.visible = false


func interact() -> void:
	if owner.get_parent().has_method("nextLevel"):
		owner.get_parent().nextLevel()
	print_debug("Player interacted with: " + self.name)

func switchState(desiredState : Pwr.PowerState, force : bool) -> void:
	if current_state != desiredState or force:
		match desiredState:
			Pwr.PowerState.ON:
				$MainSprite.play("Opening")
				$InteractionArea2D/CollisionShape2D.disabled = false
				current_state = Pwr.PowerState.ON
			Pwr.PowerState.OFF:
				$MainSprite.play("Closing")
				$InteractionArea2D/CollisionShape2D.disabled = true
				current_state = Pwr.PowerState.OFF
			_:
				pass;
