#Firstly, this has to have 3 Node2Ds which themselves serve no purpose apart from being containers,
#They are required for functioning and the 3 Nodes Should be: "Emitters", "Wires" and "Receivers"

#Emitters should contain everything that can emit a powerstate such as Levers and SwitchBoxes
#Wires should contain PowerLine2Ds that are connected to an emitter and a reciever and only transport info
#Receivers should contain things that can be turned on and off or opened and closed, such as fences and doors

class_name PowerGrid
extends Node

var emitters : Node
var wires : Node
var receivers : Node

func _ready() -> void:
	if self.has_node("Emitters"):
		emitters = self.get_node("Emitters")
	else:
		printerr("NO EMITTERS IN POWERGRID: " + self.name)
	
	if self.has_node("Wires"):
		wires = self.get_node("Wires")
	else:
		printerr("NO WIRES IN POWERGRID: " + self.name)
	
	if self.has_node("Receivers"):
		receivers = self.get_node("Receivers")
	else:
		printerr("NO Receivers IN POWERGRID: " + self.name)
	
	if emitters:
		for i in range(emitters.get_child_count()):
			if emitters.get_child(i).has_method("startSubroutine"):
				emitters.get_child(i).startSubroutine()

func refreshGrid(emitter : StaticBody2D) -> void:
	for i in range(wires.get_child_count()):
		if wires.get_child(i).emitter.name == emitter.name:
				wires.get_child(i).call_deferred("switchState",emitter.currentState, false, false)

func Reset() -> void:
	for i in range(wires.get_child_count()):
		wires.get_child(i).call_deferred("switchState", Pwr.PowerState.OFF, true, true)
	for i in range(emitters.get_child_count()):
		emitters.get_child(i).resetState()
