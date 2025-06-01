extends Node2D

@onready var cielo = $Cielo #Referencia a Cielo Sprite2D
@onready var timer = $Timer #Referencia a Timer

var colores_tormenta = [
	Color(0.565, 0.655, 0.925), #Color azul claro
	Color(0.2, 0.3, 0.6) #Color azul más oscuro
]

var indice_color = 0 #Color actual

func _ready():
	timer.wait_time = 8.0 # Establezco el tiempo entre los cambios de color (8 segundos)
	timer.timeout.connect(_on_timer_timeout)  # Conecto la señal del temporizador a la función que cambia el color
	timer.start() #Da comienzo el contador de tiempo

func _on_timer_timeout():
	var nuevo_color = colores_tormenta[indice_color] #Selecciono el siguiente color de la lista
	indice_color = (indice_color + 1) % colores_tormenta.size()#Aumento el índice
	var tween = create_tween() #Tween para suavizar la transición de colores
	tween.tween_property(cielo, "modulate", nuevo_color, 1.5) #Cambio el color despacio
