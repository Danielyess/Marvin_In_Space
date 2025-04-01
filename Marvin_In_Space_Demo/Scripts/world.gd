extends Node2D

enum CameraState{player, map, menu}

var current_state: CameraState = CameraState.menu

var mapName : String
var characterName : String

var mapSpawnPoint : Marker2D
var character : CharacterBody2D

var MapCamera : Camera2D 
var CharacterCamera : Camera2D 
var MenuCamera: Camera2D

func _ready() -> void:
	var map : Node2D
	loadMap(0)
	map = self.get_node(mapName)
	if map.has_node("Camera"):
		MapCamera = map.get_node("Camera")
	else:
		printerr("Couldn't get map camera.")
	
	if map.has_node("SpawnPoint"):
		mapSpawnPoint = map.get_node("SpawnPoint")
	else:
		printerr("Couldn't get map spawn point.")
	
	loadCharacter()
	character = self.get_node(characterName)
	resetCharacterPosition()
	if character.has_node("Camera"):
		CharacterCamera = character.get_node("Camera")
	else:
		printerr("Couldn't get character camera")
	switchCameraState(CameraState.player)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SwitchCamera"):
		match(current_state):
			CameraState.map:
				switchCameraState(CameraState.player)
			CameraState.player:
				switchCameraState(CameraState.map)
	if event.is_action_pressed("MenuButton"):
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
	var desiredMap : Node2D = load("res://Scenes/" + desiredMapName + ".tscn").instantiate()
	add_child(desiredMap)
	mapName = desiredMap.name
	pass;

func loadCharacter() -> void:
	var Character : CharacterBody2D = load("res://Scenes/character.tscn").instantiate()
	add_child(Character)
	characterName = Character.name

func resetCharacterPosition() -> void:
	character.position = mapSpawnPoint.position

func nextLevel() -> void:
	print_debug("going to next stage")

func deathAnimation() -> void:
	$DeathAnimationHandler.play("DeathScreenIn")

func deathAnimationRev() -> void:
	$DeathAnimationHandler.play("DeathScreenOut")
