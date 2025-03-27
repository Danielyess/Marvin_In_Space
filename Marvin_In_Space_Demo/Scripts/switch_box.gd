extends StaticBody2D

var isOpen : bool
var cover 


func _ready() -> void:
	$MainSprite.play("Locked")
	$InteractionSprite.visible = false
	$InteractionSprite.scale = Vector2(0.5,0.5)
	$InteractionSprite.position.y -= 30
	$BaseCollShape.disabled = true
	isOpen = false
	
	cover = load("res://Scenes/switch_box_cover.tscn").instantiate()
	pass;

func showInteract() -> void:
	if isOpen:
		$InteractionSprite.visible = true
	

func hideInteract() -> void:
	if isOpen:
		$InteractionSprite.visible = false


func openBox() -> void:
	if !isOpen:
		$MainSprite.play("Open")
		isOpen = true
		$InteractionSprite.visible = true
		add_child(cover)
		$CoverTimeoutTimer.start()

func startOpeningTimer() -> void:
	$openingTimer.start()


func _on_opening_timer_timeout() -> void:
	openBox()

func startTimer():
	if not $openingTimer.paused:
		$openingTimer.start()
	else:
		$openingTimer.paused = false

func pauseTimer():
	$openingTimer.paused = true


func _on_cover_timeout_timer_timeout() -> void:
	cover.queue_free()
