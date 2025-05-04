extends Control
func _ready():
	$BoxContainer/Button.pressed.connect(_on_button_pressed.bind("pantalla1"))
	$BoxContainer2/Button.pressed.connect(_on_button_pressed.bind("pantalla2"))
	$BoxContainer3/Button.pressed.connect(_on_button_pressed.bind("pantalla3"))

func _on_button_pressed(destino):
	match destino:
		"pantalla1":
			print("Ir a pantalla 1")
			get_tree().change_scene_to_file("res://escenas/presentacionLV1.tscn")
		"pantalla2":
			print("Ir a pantalla 2")
			
		"pantalla3":
			print("Ir a pantalla 3")
			get_tree().quit()
