extends Control

var want_quit_game = false

func _ready() -> void:
	hide_menus()
	initialize_interacted_ui()
	initialize_tasks()
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()

func hide_menus():
	$pause_menu.visible = false
	$settings.visible = false
	$controls.visible = false
	$player_ui.visible = true
	$confirmation.visible = false

#TASKS
func initialize_tasks():
	set_task("Check if anyone is home and ask for help")

func set_task(task_text: String):
	$task_ui/notification.play()
	await get_tree().create_timer(1.5, false).timeout
	$task_ui/task/task_text.text = task_text

#INTERACTIONS UI
func initialize_interacted_ui():
	initialize_safe()

func open_interacted_ui():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func close_interacted_ui():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
#SAFE UI
@onready var safe = get_tree().current_scene.get_node("house/NavigationRegion3D/basement/safe")

func initialize_safe():
	$interactive_ui/safe_ui.visible = false
	
func open_safe_password():
	if Global.safe_interactable:
		open_interacted_ui()
		$interactive_ui/safe_ui/frame/passcode_text.text = ""
		$interactive_ui/safe_ui.visible = true

func close_safe_password():
	close_interacted_ui()
	$interactive_ui/safe_ui.visible = false
	
func confirm_safe_password():
	if Global.safe_password == $interactive_ui/safe_ui/frame/passcode_text.text:
		Global.safe_interactable = false
		close_safe_password()
		safe.open_safe()

#MENU
func play_hover():
	$hover.play()

func pause_game():
	if get_tree().paused:
		return
	$pause_menu.visible = true
	$player_ui.visible = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func resume_game():
	$interact.play()
	$pause_menu.visible = false
	$player_ui.visible = true
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func main_menu():
	$interact.play()
	want_quit_game = false
	$confirmation.visible = true
	
func quit_game():
	$interact.play()
	want_quit_game = true
	$confirmation.visible = true
	
func confirm_exit_game():
	$interact.play()
	await get_tree().create_timer(0.5, true).timeout
	hide_menus()
	if want_quit_game:
		get_tree().quit()
	else:
		get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func back_confirmation():
	$interact.play()
	want_quit_game = false
	$confirmation.visible = false

func open_settings():
	$interact.play()
	$pause_menu.visible = false
	$settings.visible = true
	
func open_controls():
	$interact.play()
	$pause_menu.visible = false
	$controls.visible = true
	
func close_menus():
	$interact.play()
	$settings.visible = false
	$controls.visible = false
	$pause_menu.visible = true
