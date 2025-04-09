extends StaticBody2D

func pickUp(character : CharacterBody2D) -> void:
	character.get_parent().collectibleGot = true
	character.RemoveInteractable($Interact_Area2D)
	queue_free()
