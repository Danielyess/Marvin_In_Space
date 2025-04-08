#This node should be used when you want something to happen if Marvin's screwdriver touches it
#Currently used by: SwitchBox in order to open it's cover and the electric fence to give Marvin 1 jumpcharge
extends Area2D

func _init() -> void:
	collision_layer = 0b0
	collision_mask = 0b1000


func _ready() -> void:
	connect("area_entered", self.on_area_entered)
	connect("area_exited", self.on_area_exited)


func on_area_entered(screwDriver) -> void:
	if screwDriver == null :
		return
	
	if screwDriver.owner.get_parent().has_method("addJumpCharge") and owner.canGiveJump:
		screwDriver.owner.get_parent().addJumpCharge(1, false)
	
	if owner.has_method("startTimer"):
		owner.startTimer()

func on_area_exited(screwDriver) -> void:
	if screwDriver == null :
		return
	
	if owner.has_method("pauseTimer"):
		owner.pauseTimer()
