extends StaticBody2D

func _ready() -> void:
	$MainSprite.play("Default")
	$BaseCollShape.disabled = true
	$InteractionSprite.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y -= 30 * (self.scale.x + self.scale.y) /2
	
	
func showInteract() -> void:
	$InteractionSprite.visible = true
	

func hideInteract() -> void:
	$InteractionSprite.visible = false


func interact() -> void:
	print_debug("Player interacted with: " + self.name)
