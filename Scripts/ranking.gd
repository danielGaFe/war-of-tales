extends Control

var puntos_actuales: int = 0# Variable para almacenar los puntos del jugador

@onready var name_input = $nombre # Referencia al campo de texto donde el jugador escribe su nombre
@onready var save_button = $guardar# Referencia al botón para guardar la puntuación
@onready var ranking_display = $ranking# Referencia al área que muestra el ranking


func _ready():
	puntos_actuales = SenalGlobal.puntos_para_ranking # Obtiene los puntos del jugador desde una variable global
	save_button.pressed.connect(_on_save_button_pressed) # Conecta el botón guardar a su función correspondiente
	_actualizar_ranking()# Llama a la función que actualiza el ranking en pantalla
	$BoxContainer/salir.pressed.connect(_on_button_pressed.bind("salir"))# Conecta el botón "salir"
	$BoxContainer/repetir.pressed.connect(_on_button_pressed.bind("repetir"))# Conecta el botón "repetir"

func _on_save_button_pressed():# Obtiene el nombre ingresado y quita espacios extra
	var nombre = name_input.text.strip_edges()
	if nombre == "":
		nombre = "Anonimo"# Si no se ingresó nada, introduce automáticamente el nomnbre "Anonimo"
	SenalGlobal.guardar_puntuacion(nombre, puntos_actuales)# Guarda la puntuación en el sistema global
	_actualizar_ranking() # actualiza el ranking
	save_button.disabled = true# Desactiva el botón para que no se guarde varias veces
	name_input.editable = false # Evita seguir editando el nombre tras guardar

func _actualizar_ranking():
	var ranking = SenalGlobal.obtener_ranking()# Obtiene el top 5 de puntuaciones
	var texto = "Ranking Top 5:\n" 
	for i in range(ranking.size()):
		var entrada = ranking[i]
		texto += str(i + 1) + ". " + entrada["nombre"] + " — " + str(entrada["puntos"]) + "\n"
	ranking_display.bbcode_text = texto# Muestra el texto en la interfaz

func _on_button_pressed(destino):
	match destino:
		"repetir":
			print("Ir a pantalla 1")
			get_tree().change_scene_to_file("res://escenas/presentacionLV1.tscn")
		"salir":
			get_tree().quit()
