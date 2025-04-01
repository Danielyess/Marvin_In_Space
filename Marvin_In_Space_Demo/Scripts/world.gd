extends Node2D

enum CameraState{player, map, menu}

@export var level_index : int = 0

var current_state: CameraState = CameraState.menu
var mapSpawnPoint : Marker2D
var Character : CharacterBody2D
var map : Node2D

var MapCamera : Camera2D 
var CharacterCamera : Camera2D 
var MenuCamera: Camera2D

func _ready() -> void:
	var mainMenu : Control = load("res://Scenes/main_menu.tscn").instantiate()
	add_child(mainMenu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SwitchCamera"):
		match(current_state):
			CameraState.map:
				switchCameraState(CameraState.player)
			CameraState.player:
				switchCameraState(CameraState.map)
	if event.is_action_pressed("MenuButton"):
		#loadMenu()
		switchCameraState(CameraState.menu)

func switchCameraState(desired_camera_state: CameraState) -> void:
	match desired_camera_state:
		CameraState.player: 
			current_state = CameraState.player
			MapCamera.enabled = false
			CharacterCamera.enabled = true
		CameraState.map:
			current_state = CameraState.map
			MapCamera.enabled = true
			MapCamera.position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
			CharacterCamera.enabled = false
		CameraState.menu:
			current_state = CameraState.player
			#MenuCamera.enabled = true
			MapCamera.enabled = false
			CharacterCamera.enabled = false
		_:
			pass;

func loadMap(mapIndex : int) -> void:
	var desiredMapName : String = "map_" + str(mapIndex)
	map = load("res://Scenes/" + desiredMapName + ".tscn").instantiate()
	add_child(map)
	if map.has_node("Camera"):
		MapCamera = map.get_node("Camera")
	else:
		printerr("Couldn't get map camera.")
		
	if map.has_node("SpawnPoint"):
		mapSpawnPoint = map.get_node("SpawnPoint")
	else:
		printerr("Couldn't get map spawn point.")

func loadCharacter() -> void:
	Character = load("res://Scenes/character.tscn").instantiate()
	add_child(Character)
	if Character.has_node("Camera"):
		CharacterCamera = Character.get_node("Camera")
	else:
		printerr("Couldn't get character camera")
	resetCharacterPosition()

#func loadMenu() -> void:
	#


func resetCharacterPosition() -> void:
	Character.position = mapSpawnPoint.position
	pass;

func nextLevel() -> void:
	deathAnimation()
	map.queue_free()
	level_index+=1;
	initLevel(level_index)
	deathAnimationRev()

func deathAnimation() -> void:
	$DeathAnimationHandler.play("DeathScreenIn")

func deathAnimationRev() -> void:
	$DeathAnimationHandler.play("DeathScreenOut")

func initLevel(level : int) -> void:
	level_index = level
	loadMap(level)
	if level <= 1:
		loadCharacter()
	if level < 3:
		Character.maxJumpCharges = 1
		Character.updateJumpChargeSprite()
	if level < 4 :
		Character.canDash = false 
		Character.updateDashSprite()
	resetCharacterPosition()
	switchCameraState(CameraState.player)
