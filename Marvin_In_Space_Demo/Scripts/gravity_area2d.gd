#For the current iteration of this area it cannot be 0g's because 
#it would result in a division by 0

#The aformentioned problem is handled by an if in the ready() function for now

class_name GravityArea2D
extends Area2D

@export var gravityMult : float = 1

@onready var GravityLabel : Label = $Label

func _init() -> void:
	collision_layer = 0b0
	collision_mask = 0b100

func _ready() -> void:
	connect("area_entered",self.on_area_entered)
	connect("area_exited", self.on_area_exited)
	$CollisionShape2D/ColorRect.color = Color((gravityMult/2.5),1-gravityMult,(1-gravityMult/2.5),0.1)
	GravityLabel.scale.x = 1.00/self.scale.x
	GravityLabel.scale.y = 1.00/self.scale.y
	GravityLabel.add_theme_font_size_override("font_size", 39 * int(min(self.scale.x, self.scale.y)))
	GravityLabel.text = str(gravityMult) + "g"
	GravityLabel.add_theme_color_override("font_color",  Color((gravityMult/2.5),1-gravityMult,(1-gravityMult/2.5),1))
	if gravityMult == 0:
		gravityMult = 0.0000001

func on_area_entered(area) -> void:
	if area == null:
		return
	
	if area.owner.has_method("multGravity"):
		area.owner.multGravity(gravityMult)

func on_area_exited(area) -> void:
	if area == null:
		return
	
	if area.owner.has_method("multGravity"):
		area.owner.multGravity(1/gravityMult)
