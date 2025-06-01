extends Control

func _ready():
	$BoxContainer/salir.pressed.connect(_on_button_pressed.bind("salir"))# Conecta el botón "salir" al método, pasándole el valor "salir"
	$BoxContainer/atras.pressed.connect(_on_button_pressed.bind("atras"))# Conecta el botón "atrás" al método, pasándole el valor "atrás"
	
func _on_button_pressed(destino):
	match destino: #Si destino es igual a...
		"atras": #atras
			get_tree().change_scene_to_file("res://escenas/menuPrincipal.tscn")#Voy a la escena indicada
		"salir": #salir
			get_tree().quit()#Cierro el juego
