extends Node2D

enum CameraState{player, Level, menu}

@export var levelIndex : int = 0

var currentState: CameraState = CameraState.menu
var LevelSpawnPoint : Marker2D
var Player : CharacterBody2D
var Level : Node2D
var MainMenu : Control
var PauseMenu : Control
var EndScreen : Control

var LevelCamera : Camera2D 
var PlayerCamera : Camera2D 
var MenuCamera: Camera2D

var collectibleGot : bool = true

func _ready() -> void:
	$DeathAnimContainer/DeathAnimationHandler.process_mode = Node.PROCESS_MODE_ALWAYS
	PauseMenu = load("res://Scenes/pause_menu.tscn").instantiate()
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	MainMenu  = load("res://Scenes/main_menu.tscn").instantiate()
	MainMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	EndScreen = load("res://Scenes/end_screen.tscn").instantiate()
	EndScreen.process_mode = Node.PROCESS_MODE_ALWAYS
	showMainMenu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SwitchCamera"):
		match(currentState):
			CameraState.Level:
				switchCameraState(CameraState.player)
			CameraState.player:
				switchCameraState(CameraState.Level)
	if event.is_action_pressed("MenuButton"):
		if not MainMenu.is_inside_tree():
			get_tree().paused = true
			loadMenu()
			switchCameraState(CameraState.menu)	

func switchCameraState(desiredCameraState: CameraState) -> void:
	match desiredCameraState:
		CameraState.player: 
			currentState = CameraState.player
			PlayerCamera.make_current()
		CameraState.Level:
			currentState = CameraState.Level
			LevelCamera.make_current()
			LevelCamera.position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
		CameraState.menu:
			currentState = CameraState.menu
			MenuCamera.make_current()
		_:
			pass;

func loadLevel() -> void:
	if levelIndex < 10:
		var desiredLevelName : String = "level_" + str(levelIndex)
		Level = load("res://Scenes/Levels/" + desiredLevelName + ".tscn").instantiate()
	else:
		Level = load("res://Scenes/Levels/final_level_bridge.tscn").instantiate()
	
	
	add_child(Level)
	if Level.has_node("Camera"):
		LevelCamera = Level.get_node("Camera")
	else:
		printerr("Couldn't get Level camera.")
		
	if Level.get_node("Objects").has_node("SpawnPoint"):
		LevelSpawnPoint = Level.get_node("Objects").get_node("SpawnPoint")
	else:
		printerr("Couldn't get Level spawn point.")

func loadPlayer() -> void:
	Player = load("res://Scenes/player.tscn").instantiate()
	add_child(Player)
	if Player.has_node("Camera"):
		PlayerCamera = Player.get_node("Camera")
	else:
		printerr("Couldn't get Player camera")
	resetPlayerPosition()

func loadMenu() -> void:
	add_child(PauseMenu)
	PauseMenu.initFocus()
	if PauseMenu.has_node("Camera"):
		MenuCamera = PauseMenu.get_node("Camera")
	else:
		printerr("Menu has no Camera node!!")

func resetPlayerPosition() -> void:
	Player.velocity = Vector2(0.0,0.0)
	Player.position = LevelSpawnPoint.position

func nextLevel() -> void:
	deathAnimation()
	LevelCamera = null
	LevelSpawnPoint = null
	Level.queue_free()
	levelIndex+=1;
	initLevel()
	deathAnimationRev()

func deathAnimation() -> void:
	$DeathAnimContainer/DeathAnimationHandler.play("DeathScreenIn")

func deathAnimationRev() -> void:
	$DeathAnimContainer/DeathAnimationHandler.play("DeathScreenOut")

func initLevel(level : int = levelIndex) -> void:
	if MainMenu.is_inside_tree():
		remove_child(MainMenu)
	levelIndex = level
	loadLevel()
	if not Player:
		loadPlayer()
	if level < 3:
		Player.maxJumpCharges = 1
		Player.updateJumpChargeSprite()
	if level < 4 :
		Player.canTeleport = false 
		Player.updateTeleportSprite()
	resetPlayerPosition()
	switchCameraState(CameraState.player)

func showMainMenu() -> void:
	if Level:
		Level.queue_free()
	if Player:
		Player.queue_free()
	if EndScreen.is_inside_tree():
		self.remove_child(EndScreen)
	
	if PauseMenu.is_inside_tree():
		self.remove_child(PauseMenu)
	
	add_child(MainMenu)
	get_tree().paused = false

func resumeGame() -> void:
	get_tree().paused = false
	self.remove_child(PauseMenu)
	switchCameraState(CameraState.player)

func restartLevel() -> void:
	resetPlayerPosition()
	if Level and Level.get_node("Objects").get_node_or_null("PowerGrid"):
		Level.get_node("Objects").get_node("PowerGrid").call_deferred("Reset")

func showEndScreen() -> void:
	if Level:
		Level.queue_free()
	if Player:
		Player.queue_free()
	
	add_child(EndScreen)
