extends StaticBody2D

var isOpen : bool

func _ready() -> void:
	$MainSprite.play("Default")
	$BaseCollShape.disabled = true
	$InteractionArea2D.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y -= 30 * (self.scale.x + self.scale.y) /2
	isOpen = false


func showInteract() -> void:
	if isOpen:
		$InteractionSprite.visible = true
	

func hideInteract() -> void:
	if isOpen:
		$InteractionSprite.visible = false

func openDoor() -> void:
	if !isOpen:
		$MainSprite.play("Opening")
		isOpen = true

func closeDoor() -> void:
	if isOpen:
		$MainSprite.play("Closing")
		isOpen = false
