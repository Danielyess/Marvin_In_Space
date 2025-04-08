extends Node2D

enum CameraState{player, map, menu}

@export var levelIndex : int = 0

var currentState: CameraState = CameraState.menu
var mapSpawnPoint : Marker2D
var Character : CharacterBody2D
var Map : Node2D
var Menu : Control

var MapCamera : Camera2D 
var CharacterCamera : Camera2D 
var MenuCamera: Camera2D

func _ready() -> void:
	$DeathAnimationHandler.process_mode = Node.PROCESS_MODE_ALWAYS
	Menu = load("res://Scenes/menu.tscn").instantiate()
	showMainMenu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SwitchCamera"):
		match(currentState):
			CameraState.map:
				switchCameraState(CameraState.player)
			CameraState.player:
				switchCameraState(CameraState.map)
	if event.is_action_pressed("MenuButton"):
		if not self.has_node("Main Menu"):
			get_tree().paused = true
			loadMenu()
			switchCameraState(CameraState.menu)	

func switchCameraState(desired_camera_state: CameraState) -> void:
	match desired_camera_state:
		CameraState.player: 
			currentState = CameraState.player
			CharacterCamera.make_current()
		CameraState.map:
			currentState = CameraState.map
			MapCamera.make_current()
			MapCamera.position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
		CameraState.menu:
			currentState = CameraState.menu
			MenuCamera.make_current()
		_:
			pass;

func loadMap(mapIndex : int) -> void:
	var desiredMapName : String = "map_" + str(mapIndex)
	Map = load("res://Scenes/Maps/" + desiredMapName + ".tscn").instantiate()
	add_child(Map)
	if Map.has_node("Camera"):
		MapCamera = Map.get_node("Camera")
	else:
		printerr("Couldn't get map camera.")
		
	if Map.get_node("Objects").has_node("SpawnPoint"):
		mapSpawnPoint = Map.get_node("Objects").get_node("SpawnPoint")
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

func loadMenu() -> void:
	Menu.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(Menu)
	if Menu.has_node("Camera"):
		MenuCamera = Menu.get_node("Camera")
	else:
		printerr("Menu has no Camera node!!")

func resetCharacterPosition() -> void:
	Character.velocity = Vector2(0.0,0.0)
	Character.position = mapSpawnPoint.position

func nextLevel() -> void:
	deathAnimation()
	Map.queue_free()
	levelIndex+=1;
	initLevel(levelIndex)
	deathAnimationRev()

func deathAnimation() -> void:
	$DeathAnimationHandler.play("DeathScreenIn")

func deathAnimationRev() -> void:
	$DeathAnimationHandler.play("DeathScreenOut")

func initLevel(level : int) -> void:
	levelIndex = level
	loadMap(level)
	if not Character:
		loadCharacter()
	if level < 3:
		Character.maxJumpCharges = 1
		Character.updateJumpChargeSprite()
	if level < 4 :
		Character.canTeleport = false 
		Character.updateTeleportSprite()
	resetCharacterPosition()
	switchCameraState(CameraState.player)

func showMainMenu() -> void:
	if Character:
		Character.queue_free()
	
	if Map:
		Map.queue_free()
	
	var mainMenu : Control = load("res://Scenes/main_menu.tscn").instantiate()
	add_child(mainMenu)

	if self.has_node("Menu"):
		self.remove_child(Menu)
	
	get_tree().paused = false

func resume() -> void:
	get_tree().paused = false
	self.remove_child(Menu)
	switchCameraState(CameraState.player)

func restartMap():
	resetCharacterPosition()
	if Map and Map.get_node("Objects").get_node_or_null("PowerGrid"):
		Map.get_node("Objects").get_node("PowerGrid").Reset()
	pass;
