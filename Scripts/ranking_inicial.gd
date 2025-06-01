extends Control

var puntos_actuales: int = 0# Variable para almacenar los puntos del jugador
@onready var name_input = $nombre# Referencia al campo de texto donde el jugador escribe su nombre
@onready var ranking_display = $ranking# Referencia al botón para guardar la puntuación


func _ready():
	_actualizar_ranking()# Llama a la función que actualiza el ranking en pantalla
	puntos_actuales = SenalGlobal.puntos_para_ranking# Obtiene los puntos del jugador desde una variable global
	$BoxContainer/salir.pressed.connect(_on_button_pressed.bind("salir"))# Conecta el botón "salir"
	$BoxContainer/atras.pressed.connect(_on_button_pressed.bind("atras"))# Conecta el botón "atrás"

func _actualizar_ranking():
	var ranking = SenalGlobal.obtener_ranking()# Obtiene el top 5 de puntuaciones
	var texto = "Ranking Top 5:\n" 
	for i in range(ranking.size()):
		var entrada = ranking[i]
		texto += str(i + 1) + ". " + entrada["nombre"] + " — " + str(entrada["puntos"]) + "\n"
	ranking_display.bbcode_text = texto# Muestra el texto en la interfaz

func _on_button_pressed(destino):
	match destino:
		"atras":
			print("Ir a pantalla 1")
			get_tree().change_scene_to_file("res://escenas/menuPrincipal.tscn")
		"salir":
			get_tree().quit()
