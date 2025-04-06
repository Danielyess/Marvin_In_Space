extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.jumpCharges = 2
	character.updateJumpChargeSprite()
	refresh()

func refresh() -> void:
	$Sprite2D.self_modulate = Color(1,1,1,0.25)
	$Interact_Area2D/InteractColl2D.set_deferred("disabled", true)
	$Timer.start()


func _on_timer_timeout() -> void:
	$Sprite2D.self_modulate = Color(1,1,1,1)	
	$Interact_Area2D/InteractColl2D.set_deferred("disabled", false)
