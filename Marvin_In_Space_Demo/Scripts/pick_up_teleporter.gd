extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.canTeleport = 1
	character.updateTeleportSprite()
	character.removeInteractable($Interact_Area2D)
	queue_free()
