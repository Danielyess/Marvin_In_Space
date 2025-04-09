extends Control

enum LogicGate{
	None,
	Not,
	Or,
	And,
	NAnd,
	NOr,
	XOr
}

var graphic : TextureRect

func loadGraphic(preset : int, gate0 : LogicGate, gate1 : LogicGate = LogicGate.None, gate2 : LogicGate = LogicGate.None, gate3 : LogicGate = LogicGate.None) -> void:
	if preset <= 0:
		return;
	elif preset == 1:
		initOne(gate0)
	elif preset < 3:
		initTwo(gate0, gate1)
	elif preset == 3:
		initTwoZeroOne(gate0,gate1)
	elif preset < 7:
		initThreeBase(gate0, gate1, gate2)
	elif preset == 7:
		initThreeSpecial(gate0, gate1, gate2, LogicGate.None, LogicGate.None)
	elif preset == 8:
		initThreeSpecial(gate0, gate1, gate2, gate3, LogicGate.None)
	else:
		initThreeSpecial(gate0, gate1, gate2, LogicGate.None, gate3)
	
	add_child(graphic)

func initOne(gate0 : LogicGate) -> void:
	graphic = load("res://Scenes/SwitchBoxPresets/switch_box_preset_one.tscn").instantiate()
	graphic.get_node("Gate0").texture = getGate(gate0)

func initTwo(gate0: LogicGate, gate1: LogicGate) -> void:
	graphic = load("res://Scenes/SwitchBoxPresets/switch_box_preset_two_x.tscn").instantiate()
	graphic.get_node("Gate0").texture = getGate(gate0)
	graphic.get_node("Gate1").texture = getGate(gate1)

func initTwoZeroOne(gate0: LogicGate, gate1: LogicGate) -> void:
	graphic = load("res://Scenes/SwitchBoxPresets/switch_box_preset_two_x.tscn").instantiate()
	graphic.get_node("Gate0").texture = getGate(gate0)
	graphic.get_node("Gate2").texture = getGate(gate1)

func initThreeBase(gate0 : LogicGate, gate1 : LogicGate, gate2 : LogicGate) -> void:
	graphic = load("res://Scenes/SwitchBoxPresets/switch_box_preset_three_base_x.tscn").instantiate()
	graphic.get_node("Gate0").texture = getGate(gate0)
	graphic.get_node("Gate1").texture = getGate(gate1)
	graphic.get_node("Gate2").texture = getGate(gate2)

func initThreeSpecial(gate0 : LogicGate, gate1 : LogicGate, gate2 : LogicGate, gate3l : LogicGate, gate3r : LogicGate) -> void:
	graphic = load("res://Scenes/SwitchBoxPresets/switch_box_preset_three_special_x.tscn").instantiate()
	graphic.get_node("Gate0").texture = getGate(gate0)
	graphic.get_node("Gate1").texture = getGate(gate1)
	graphic.get_node("Gate2").texture = getGate(gate2)
	graphic.get_node("Gate3L").texture = getGate(gate3l)
	graphic.get_node("Gate3R").texture = getGate(gate3r)

func getGate(gate : LogicGate) -> CompressedTexture2D:
	match gate:
		LogicGate.None:
			return load("res://resources/Sprites/SwitchBoxPresets/NONE.png")
		LogicGate.Not:
			return load("res://resources/Sprites/SwitchBoxPresets/NOT.png")
		LogicGate.Or:
			return load("res://resources/Sprites/SwitchBoxPresets/OR.png")
		LogicGate.And:
			return load("res://resources/Sprites/SwitchBoxPresets/AND.png")
		LogicGate.NAnd:
			return load("res://resources/Sprites/SwitchBoxPresets/NAND.png")
		LogicGate.NOr:
			return load("res://resources/Sprites/SwitchBoxPresets/NOR.png")
		LogicGate.XOr:
			return load("res://resources/Sprites/SwitchBoxPresets/XOR.png")
		_:
			return load("res://resources/Sprites/SwitchBoxPresets/NONE.png")

func _on_ok_button_pressed() -> void:
	get_tree().paused = false
	get_parent().remove_child(self)
