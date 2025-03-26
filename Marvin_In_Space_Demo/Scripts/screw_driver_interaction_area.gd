extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 4


func _ready() -> void:
	connect("area_entered", self.on_area_entered)
	connect("area_exited", self.on_area_exited)


func on_area_entered(screwDriver) -> void:
	if screwDriver == null :
		return
	
	if owner.has_method("startTimer"):
		owner.startTimer()

func on_area_exited(screwDriver) -> void:
	if screwDriver == null :
		return
	
	if owner.has_method("pauseTimer"):
		owner.pauseTimer()
