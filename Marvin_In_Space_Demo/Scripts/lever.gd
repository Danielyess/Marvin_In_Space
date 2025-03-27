extends StaticBody2D

enum State{On, Off}

var current_state : State

func _ready() -> void:
	$MainSprite.play("Default")
	$BaseCollShape.disabled = true
	$InteractionSprite.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y -= 30 * (self.scale.x + self.scale.y) /2
	current_state = State.Off
	
	
func showInteract() -> void:
	$InteractionSprite.visible = true
	

func hideInteract() -> void:
	$InteractionSprite.visible = false


func interact() -> void:
	match(current_state):
		State.On: 
			$MainSprite.play("Off")
			current_state = State.Off
		State.Off:
			$MainSprite.play("On")
			current_state = State.On
