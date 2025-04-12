extends CharacterBody2D

func _ready() -> void:
	scale = get_parent().scale * 0.75

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
