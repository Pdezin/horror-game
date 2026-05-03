extends CanvasLayer

func _ready() -> void:
	set_checkbox_setting("glow", $glow_check)
	set_checkbox_setting("ssil", $ssil_check)
	set_checkbox_setting("vsync", $vsync_check)
	
	set_option_button_setting("fps_cap", $fpscap_dropdown)
	set_option_button_setting("antialiasing", $antialiasing_dropdown)
	set_option_button_setting("shadows", $shadow_quality_dropdown)
	set_option_button_setting("window_mode", $window_mode_dropdown)
	
	set_slider_setting("look_speed", $camera_sense_slider)
	set_slider_setting("music_volume", $musicvolume_slider)
	set_slider_setting("sfx_volume", $sfxvolume_slider)
	set_slider_setting("master_volume", $mastervolume_slider)
	set_slider_setting("scale_3d", $scaling_slider)
	
	set_glow($glow_check.button_pressed)
	set_ssil($ssil_check.button_pressed)
	set_vsync($vsync_check.button_pressed)
	
	set_fps_cap($fpscap_dropdown.selected)
	set_aa($antialiasing_dropdown.selected)
	set_shadows($shadow_quality_dropdown.selected)
	set_window_mode($window_mode_dropdown.selected)
	
	set_look_speed($camera_sense_slider.value)
	set_music_volume($musicvolume_slider.value)
	set_sfx_volume($sfxvolume_slider.value)
	set_master_volume($mastervolume_slider.value)
	scale_3d($scaling_slider.value)
	
func save_setting(setting_name: String, value):
	var save = FileAccess.open("user://" + setting_name + "_config.djheizan", FileAccess.WRITE)
	save.store_string(str(value))
	save.close()
	
func load_setting(setting_name: String) -> String:
	var value = ""
	var load = FileAccess.open("user://" + setting_name + "_config.djheizan", FileAccess.READ)
	if load:
		value = load.get_as_text()
		load.close()
	return value
	
func set_checkbox_setting(setting_name, checkbox: CheckBox):
	var value = load_setting(setting_name)
	if value == "true":
		checkbox.button_pressed = true
	elif value == "false":
		checkbox.button_pressed = false
	
func set_option_button_setting(setting_name, option_button: OptionButton):
	var value = load_setting(setting_name)
	if value != "":
		option_button.selected = int(value)
	
func set_slider_setting(setting_name, slider: HSlider):	
	var value = load_setting(setting_name)
	if value != "":
		slider.value = float(value)

func scale_3d(value):
	save_setting("scale_3d", value)
	get_viewport().scaling_3d_scale = value

func set_master_volume(value):
	save_setting("master_volume", value)
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func set_sfx_volume(value):
	save_setting("sfx_volume", value)
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func set_music_volume(value):
	save_setting("music_volume", value)
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	
func set_look_speed(value):
	save_setting("look_speed", value)
	Global.camera_sensitivity = value

func set_window_mode(index):
	save_setting("window_mode", index)
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_shadows(index):
	save_setting("shadows", index)
	if index == 0:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
	elif index == 1:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
	elif index == 2:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
	elif index == 3:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
	elif index == 4:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)

func set_aa(index):
	save_setting("antialiasing", index)
	if index == 0:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 1:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		get_viewport().use_taa = false
	elif index == 2:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = true
	if index == 3:
		get_viewport().msaa_3d = Viewport.MSAA_2X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	if index == 4:
		get_viewport().msaa_3d = Viewport.MSAA_4X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	if index == 5:
		get_viewport().msaa_3d = Viewport.MSAA_8X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false

func set_fps_cap(index):
	save_setting("fps_cap", index)
	if index == 0:
		Engine.max_fps = 0
	elif index == 1:
		Engine.max_fps = 30
	elif index == 2:
		Engine.max_fps = 60

func set_vsync(toogle):
	save_setting("vsync", toogle)
	if toogle:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func set_ssil(toogle):
	save_setting("ssil", toogle)
	Global.ssil_enabled = toogle

func set_glow(toogle):
	save_setting("glow", toogle)
	Global.glow_enabled = toogle
