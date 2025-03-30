extends StaticBody2D

@export var current_state : Pwr.PowerState = Pwr.PowerState.OFF

signal stateChanged(emitter : StaticBody2D)

func _ready() -> void:
	switchState(current_state,true)
	if current_state == Pwr.PowerState.ON:
		$MainSprite.play("DefaultON")
	else:
		$MainSprite.play("DefaultOFF")
	
	$BaseCollShape.disabled = true
	$InteractionSprite.visible = false
	$InteractionSprite.scale = self.scale * 0.5
	$InteractionSprite.position.y = -30 * (self.scale.x + self.scale.y) /2
	connect("stateChanged", $"../..".refreshGrid)

func showInteract() -> void:
	$InteractionSprite.visible = true
	

func hideInteract() -> void:
	$InteractionSprite.visible = false


func interact() -> void:
	if current_state == Pwr.PowerState.ON:
		switchState(Pwr.PowerState.OFF,false)
	else:
		switchState(Pwr.PowerState.ON,false)

func switchState(desired_state : Pwr.PowerState, force : bool) -> void:
	if current_state != desired_state or force:
		match(desired_state):
			Pwr.PowerState.OFF: 
				$MainSprite.play("Off")
				current_state = Pwr.PowerState.OFF
			Pwr.PowerState.ON:
				$MainSprite.play("On")
				current_state = Pwr.PowerState.ON
		emit_signal("stateChanged", self)
