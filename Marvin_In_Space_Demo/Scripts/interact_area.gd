#Should be used when the player can interact with something or with the collectables
#For now the character can interact with Levers, end-of-level-doors and switchboxes
#Collectables are: PickUpJetpack, PickUpTeleporter, JetpackRefresh

class_name Interact_Area2D
extends Area2D

func _init() -> void:
	self.collision_layer = 0b0
	self.collision_mask = 0b100

func _ready() -> void:
	connect("area_entered", self.onEnter)
	connect("area_exited", self.onExit)


func onEnter(interactionArea : Area2D) -> void:
	if interactionArea == null:
		return;
		
	if interactionArea.owner.has_method("addInteractable"):
		interactionArea.owner.addInteractable(self)
	
	if owner.has_method("showInteract"):
		owner.showInteract()
	
	#This is used for the Jetpack and the Teleport pickups
	if owner.has_method("pickUp"):
		owner.pickUp(interactionArea.owner)

func onExit(interactionArea : Area2D) -> void:
	if owner == null:
		return
		
	if interactionArea.owner.has_method("removeInteractable"):
		interactionArea.owner.removeInteractable(self)
	
	if owner.has_method("hideInteract"):
		owner.hideInteract()

func interact():
	if owner.has_method("interact"):
		owner.interact()
