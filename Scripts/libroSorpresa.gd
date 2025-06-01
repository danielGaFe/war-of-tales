extends CharacterBody2D

@onready var anima_libro = $AnimatedSprite2D #Referencia a la animación del libro

#Escenas precargadas desde el editor de Godot son las hojas de poderes
@export var agua: PackedScene
@export var fuego: PackedScene
@export var tierra: PackedScene

var roto = false# Variable de control de rotura del libro

func _ready():
	randomize()  #aplicamos un randomize para que las hojas con los poderes sean aleatorias
	anima_libro.play("book") #Comienza la animación del libro

func recibir_golpe():
	if roto:
		return  # Si libro está roto no hacemos nada
	roto = true  # Si nio está roto marcamos que ya está roto
	var escenas = [agua, fuego, tierra]# Lista con las tres escenas posibles a instanciar
	var aleatoria = escenas[randi() % escenas.size()]# Selección aleatoria de una de las escenas
	if aleatoria:# Si se ha seleccionado correctamente una escena
		var instancia = aleatoria.instantiate()# Instancia la escena aleatoria
		get_parent().add_child(instancia)   # La añade al mismo nodo padre que el libro
		instancia.position = position      # Le asigna la misma posición local que tenía el libro
	queue_free() # Elimina el libro de la escena
	
# Función que se activa cuando bala entra en contacto con libro
func _on_area_entered(area):
	if area.has_method("recibir_golpe"):# Llama a la función recibir_golpe() 
		area.recibir_golpe()
		queue_free()  # La bala desaparece
