#Should only be used once, when the character doesn't have its teleporter yet and we give it to it
extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.canTeleport = true
	character.updateTeleportSprite()
	character.removeInteractable($Interact_Area2D)
	queue_free()
