#Should be used with the purpose of giving the player back jumpCharges which are used when jumping (DUH!!!)

extends StaticBody2D

@export var plusJumpCharges : int = 2

func pickUp(character : CharacterBody2D) -> void:
	character.addJumpCharge(2, true)
	character.updateJumpChargeSprite()
	refresh()

func refresh() -> void:
	$Sprite2D.self_modulate = Color(1,1,1,0.25)
	$Interact_Area2D/InteractColl2D.set_deferred("disabled", true)
	$Timer.start()


func _on_timer_timeout() -> void:
	$Sprite2D.self_modulate = Color(1,1,1,1)	
	$Interact_Area2D/InteractColl2D.set_deferred("disabled", false)
