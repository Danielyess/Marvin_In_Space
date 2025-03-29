extends StaticBody2D

var current_state : Pwr.PowerState
func _ready() -> void:
	$MainSprite.play("Default")
	$BaseCollShape.disabled = true
	$InteractionSprite.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2
	$InteractionSprite.position.x = 0
	$InteractionArea2D/CollisionShape2D.disabled = true
	current_state = Pwr.PowerState.OFF

func showInteract() -> void:
	$InteractionSprite.visible = true	

func hideInteract() -> void:
	$InteractionSprite.visible = false


func interact() -> void:
	if owner.get_parent().has_method("nextLevel"):
		owner.get_parent().nextLevel()
	print_debug("Player interacted with: " + self.name)

func switchState(desiredState : Pwr.PowerState) -> void:
	if current_state != desiredState:
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
