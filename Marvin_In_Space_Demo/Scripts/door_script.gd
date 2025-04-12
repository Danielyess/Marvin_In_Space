#This Scene shold be put into a PowerGrid if you want to use it with the intention
# of opening and closing it

#In the PowerGrid it should be put into the Recievers Node

#For information about Emitters see: power_grid.gd

extends StaticBody2D

@export var currentState : Pwr.PowerState = Pwr.PowerState.OFF


func _ready() -> void:
	switchState(currentState, true)
	if currentState == Pwr.PowerState.ON:
		$MainSprite.play("DefaultON")
	else:
		$MainSprite.play("DefaultOFF")

#Main fucntion that can open and close the door, this function will be called by wires if it will switch states
func switchState(desiredState : Pwr.PowerState, force : bool) -> void:
	if currentState != desiredState or force:
		match desiredState:
			Pwr.PowerState.ON:
				switchOn()
			Pwr.PowerState.OFF:
				switchOff()
			_:
				printerr("Desired state does not exist!")

#Opens the door
func switchOn() -> void:
		currentState = Pwr.PowerState.ON
		self.collision_layer = 0b0
		$MainSprite.play("Opening")

#Closes the door
func switchOff() -> void:
	currentState = Pwr.PowerState.OFF
	self.collision_layer = 0b1
	$MainSprite.play("Closing")
