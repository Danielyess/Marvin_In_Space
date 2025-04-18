extends StaticBody2D


@onready var InteractionSprite : Sprite2D = $InteractionSprite

func _ready() -> void:
	InteractionSprite.visible = false
	InteractionSprite.scale = self.scale * 0.5
	InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2

func showInteract() -> void:
	InteractionSprite.visible = true

func hideInteract() -> void:
	InteractionSprite.visible = false

func interact():
	owner.get_parent().showEndScreen()
