extends StaticBody2D

var current_state : Pwr.PowerState

signal stateChanged(emitter : StaticBody2D)

func _ready() -> void:
	$MainSprite.play("Default")
	$BaseCollShape.disabled = true
	$InteractionSprite.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2
	current_state = Pwr.PowerState.OFF
	connect("stateChanged", $"../..".refreshGrid)

func showInteract() -> void:
	$InteractionSprite.visible = true
	

func hideInteract() -> void:
	$InteractionSprite.visible = false


func interact() -> void:
	match(current_state):
		Pwr.PowerState.ON: 
			$MainSprite.play("Off")
			current_state = Pwr.PowerState.OFF
		Pwr.PowerState.OFF:
			$MainSprite.play("On")
			current_state = Pwr.PowerState.ON
	emit_signal("stateChanged", self)
