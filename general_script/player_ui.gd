extends Control

var want_quit_game = false

func _ready() -> void:
	hide_menus()
	initialize_interacted_ui()
	initialize_tasks()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()
	update_inventory()

func hide_menus():
	$pause_menu.visible = false
	$settings.visible = false
	$controls.visible = false
	$player_ui.visible = true
	$confirmation.visible = false

#INVENTORY
var inventory: Array[String] = []
@export var items_icons: Array[CompressedTexture2D]

var hasFlashlight = false
var hasShovel = false
var hasWheel = false
var hasBasementKey = false
var hasShootgun = false
var chest_keys = 0

func update_inventory():
	var hasChange = false
	
	if Global.hasFlashlight != hasFlashlight:
		if inventory.has("flashlight"):
			hasFlashlight = false
			inventory.erase("flashlight")
		else:
			hasFlashlight = true
			inventory.append("flashlight")
		hasChange = true

	if Global.hasShovel != hasShovel:
		if inventory.has("shovel"):
			hasShovel = false
			inventory.erase("shovel")
		else:
			hasShovel = true
			inventory.append("shovel")
		hasChange = true

	if Global.hasWheel != hasWheel:
		if inventory.has("wheel"):
			hasWheel = false
			inventory.erase("wheel")
		else:
			hasWheel = true
			inventory.append("wheel")
		hasChange = true

	if Global.hasBasementKey != hasBasementKey:
		if inventory.has("basement key"):
			hasBasementKey = false
			inventory.erase("basement key")
		else:
			hasBasementKey = true
			inventory.append("basement key")
		hasChange = true

	if Global.hasShotgun != hasShootgun:
		if inventory.has("shootgun"):
			hasShootgun = false
			inventory.erase("shootgun")
		else:
			hasShootgun = true
			inventory.append("shootgun")
		hasChange = true

	if Global.chest_keys != chest_keys:
		hasChange = true
		chest_keys = Global.chest_keys
		if inventory.has("chest keys"):
			if chest_keys == 0:
				inventory.erase("chest keys")
		else:
			inventory.append("chest keys")

	if !hasChange:
		return

	var left_items: Control = $player_ui/inventory/left
	var right_items: Control = $player_ui/inventory/right
	
	var total = inventory.size()
	var count = 0

	for item in left_items.get_children():
		count += 1
		item.visible = count <= total
		if item.visible:
			var name = inventory[count - 1]
			item.get_node("TextureRect").texture = return_item_icon(name)
			item.get_node("name").visible = true
			item.get_node("name").text = name
			var item_count = return_item_count(name)
			item.get_node("count").visible = item_count > 0
			item.get_node("count").text = str(item_count)
		
	for item in right_items.get_children():
		count += 1
		item.visible = count <= total
		if item.visible:
			var name = inventory[count - 1]
			item.get_node("TextureRect").texture = return_item_icon(name)
			item.get_node("name").visible = true
			item.get_node("name").text = name
			var item_count = return_item_count(name)
			item.get_node("count").visible = item_count > 0
			item.get_node("count").text = str(item_count)

func return_item_icon(name):
	var index = 0
	if name == "flashlight":
		index = 0
	if name == "shovel":
		index = 1
	if name == "wheel":
		index = 2
	if name == "basement key":
		index = 3
	if name == "shootgun":
		index = 4
	if name == "chest keys":
		index = 5
	
	return items_icons[index]

func return_item_count(name):
	if name == "chest keys":
		return Global.chest_keys
		
	return 0

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
@onready var safe = takeBasementSafe()

func takeBasementSafe():
	if get_tree().current_scene.has_node("house/NavigationRegion3D/basement/safe"):
		return get_tree().current_scene.get_node("house/NavigationRegion3D/basement/safe")
	return null

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
