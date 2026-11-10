extends Control

# ponytail: minimal single-scene menu; toggles panel visibility without scene router overhead
@onready var main_box: VBoxContainer = $CenterContainer/MainBox
@onready var options_box: VBoxContainer = $CenterContainer/OptionsBox
@onready var credits_box: VBoxContainer = $CenterContainer/CreditsBox

@onready var start_button: Button = $CenterContainer/MainBox/StartButton
@onready var options_button: Button = $CenterContainer/MainBox/OptionsButton
@onready var credits_button: Button = $CenterContainer/MainBox/CreditsButton
@onready var quit_button: Button = $CenterContainer/MainBox/QuitButton

@onready var volume_slider: HSlider = $CenterContainer/OptionsBox/VolumeSlider
@onready var volume_label: Label = $CenterContainer/OptionsBox/VolumeLabel
@onready var options_back_button: Button = $CenterContainer/OptionsBox/BackButton

@onready var credits_back_button: Button = $CenterContainer/CreditsBox/BackButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_show_options)
	credits_button.pressed.connect(_show_credits)
	quit_button.pressed.connect(_on_quit_pressed)

	options_back_button.pressed.connect(_show_main_from_options)
	credits_back_button.pressed.connect(_show_main_from_credits)

	# ponytail: native AudioServer bus 0 (Master) volume control
	var current_vol: float = db_to_linear(AudioServer.get_bus_volume_db(0))
	volume_slider.value = current_vol
	_update_volume_label(current_vol)
	volume_slider.value_changed.connect(_on_volume_changed)

	_show_panel(main_box)
	start_button.grab_focus()

func _show_panel(active: VBoxContainer) -> void:
	main_box.visible = (active == main_box)
	options_box.visible = (active == options_box)
	credits_box.visible = (active == credits_box)

func _show_options() -> void:
	_show_panel(options_box)
	volume_slider.grab_focus()

func _show_credits() -> void:
	_show_panel(credits_box)
	credits_back_button.grab_focus()

func _show_main_from_options() -> void:
	_show_panel(main_box)
	options_button.grab_focus()

func _show_main_from_credits() -> void:
	_show_panel(main_box)
	credits_button.grab_focus()

func _on_volume_changed(val: float) -> void:
	# ponytail: linear_to_db + bus mute on 0 is native Godot standard
	AudioServer.set_bus_mute(0, val <= 0.001)
	if val > 0.001:
		AudioServer.set_bus_volume_db(0, linear_to_db(val))
	_update_volume_label(val)

func _update_volume_label(val: float) -> void:
	volume_label.text = "%d%%" % int(round(val * 100))

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
