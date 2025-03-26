extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = get_parent().scale * 0.75
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
