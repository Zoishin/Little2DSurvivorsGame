extends CanvasLayer

@onready var restart_button = 	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton
@onready var quit_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var title_label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var description_label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionLabel

func _ready():
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	
func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lost!"

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_quit_button_pressed():
	get_tree().quit()
