class_name PowerGrid2D

extends Node2D

var emitters : Node2D
var wires : Node2D
var recievers : Node2D

func _ready() -> void:
	if self.has_node("Emitters"):
		emitters = self.get_node("Emitters")
	else:
		printerr("NO EMITTERS IN POWERGRID: " + self.name)
	
	if self.has_node("Wires"):
		wires = self.get_node("Wires")
	else:
		printerr("NO WIRES IN POWERGRID: " + self.name)
	
	if self.has_node("Recievers"):
		recievers = self.get_node("Recievers")
	else:
		printerr("NO RECIEVERS IN POWERGRID: " + self.name)
	
	if emitters:
		for i in range(emitters.get_child_count()):
			if emitters.get_child(i).has_method("startSubroutine"):
				emitters.get_child(i).startSubroutine()

func refreshGrid(emitter) -> void:
	for i in range(wires.get_child_count()):
		if wires.get_child(i).emitter == emitter:
			wires.get_child(i).switchState(emitter.current_state, false)
