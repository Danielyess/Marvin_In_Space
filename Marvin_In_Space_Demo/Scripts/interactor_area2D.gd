#This is the Area that interacts with the InteractArea2D
#Should be used things that can interact and NOT ON THOSE THAT CAN BE INTERACTED WITH


class_name InteractorArea2D
extends Area2D

func _init() -> void:
	self.collision_layer = 0b100
	self.collision_mask = 0b0
