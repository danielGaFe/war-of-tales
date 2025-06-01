extends Control
func _ready():
	$BoxContainer/Button.pressed.connect(_on_button_pressed.bind("pantalla1"))# Conecta el botón del primer contenedor a la función "_on_button_pressed" con el parámetro "pantalla1"
	$BoxContainer2/Button.pressed.connect(_on_button_pressed.bind("pantalla2"))# Conecta el botón del primer contenedor a la función "_on_button_pressed" con el parámetro "pantalla2"
	$BoxContainer3/Button.pressed.connect(_on_button_pressed.bind("pantalla3"))# Conecta el botón del primer contenedor a la función "_on_button_pressed" con el parámetro "pantalla3"
	$BoxContainer4/Button.pressed.connect(_on_button_pressed.bind("pantalla4"))# Conecta el botón del primer contenedor a la función "_on_button_pressed" con el parámetro "pantalla4"

func _on_button_pressed(destino):
	match destino: # Según valor de "destino", se ejecuta una acción u otrá...
		"pantalla1":#Si es pantalla1
			print("Ir a pantalla 1")
			get_tree().change_scene_to_file("res://escenas/presentacionLV1.tscn")#Se abre la escena presentacionLV1
		"pantalla2":#Si es pantalla2
			print("Ir a pantalla 2")
			get_tree().change_scene_to_file("res://escenas/rankingInicial.tscn")#Se abre la escena rankingInicial
		"pantalla3":#Si es pantalla3
			print("Ir a pantalla 3")
			get_tree().change_scene_to_file("res://escenas/controls.tscn")#Se abre la escena controls
		"pantalla3":#Si es pantalla4
			print("Ir a pantalla 4")
			get_tree().quit()#Se cierra la ventana
