extends CanvasLayer

@onready var label = $Label

func _ready():
	actualizar_label()# Actualiza el texto al iniciar la escena

func perder_vida():
	if SenalGlobal.vidas <= 1:# Si queda 1 o menos vidas...
		SenalGlobal.vidas = 0 #Se queda en 0 vidas (sin negativas)
		actualizar_label() # Actualiza el label para reflejarlo
		call_deferred("game_over") # Llama a game_over de forma diferida 
		return# Sale de la función para no restar más vidas
	SenalGlobal.vidas -= 1 # Resta una vida
	$muerte.play()# Reproduce sonido de muerte
	actualizar_label()

# Función para ganar una vida
func ganar_vida():
	SenalGlobal.vidas += 1
	actualizar_label()

# Función para actualizar label
func actualizar_label():
	label.text = "x" + str(SenalGlobal.vidas)

# Función que se ejecuta cuando se queda sin vidas
func game_over():
	print("Game Over")
	SenalGlobal.puntos_para_ranking = SenalGlobal.puntos  
	get_tree().change_scene_to_file("res://escenas/ranking.tscn")
