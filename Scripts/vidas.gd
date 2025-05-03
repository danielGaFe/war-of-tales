extends CanvasLayer

@onready var label = $Label  # Nodo del Label donde se muestran las vidas
var vidas = 3  # Número inicial de vidas

func _ready():
	actualizar_label()  #Se llama a la función actualizar_label

func perder_vida(): #Si se pierde una vida
	vidas -= 1 #Resta una vida al maracador
	actualizar_label() #Se actualiza label
	if vidas <= -1: #Comprueba si vidas es igual o menor a -1
		game_over() #De ser así se llama a game over

func ganar_vida(): #Si se gana una vida
	vidas += 1 #Se suma 1 al marcador de vidas
	actualizar_label() #Se actualiza label

func actualizar_label():
	label.text = "x" + str(vidas)  # Actualiza el texto de label

func game_over():
	print("Game Over")
	get_tree().reload_current_scene()
	# PENDIENTE DE IMPLEMENTAR GAMEOVER
