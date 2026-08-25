extends Control

func _ready() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	hide_menus()
	await get_tree().create_timer(1.0, true).timeout
	$music.play()

func new_game():
	$interact.play()
	$confirmation.visible = true

func confirm_no():
	$interact.play()
	$confirmation.visible = false

func confirm_yes():
	$interact.play()
	Global.reseat_game()
	get_tree().change_scene_to_file("res://ui/intro_story.tscn")

func open_settings():
	$interact.play()
	$main.visible = false
	$settings.visible = true
	
func open_controls():
	$interact.play()
	$main.visible = false
	$controls.visible = true
	
func open_credits():
	$interact.play()
	$main.visible = false
	$credits.visible = true

func back_main_menu():
	$interact.play()
	hide_menus()

func hide_menus():
	$main.visible = true
	$settings.visible = false
	$controls.visible = false
	$credits.visible = false
	$confirmation.visible = false

func quit_game():
	$interact.play()
	await get_tree().create_timer(0.5, true).timeout
	get_tree().quit()

func play_hover():
	$hover.play()
