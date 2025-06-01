extends Node2D  # este script está en Enemigos
# Precarga las escenas de los distintos power-ups
var agua_escena := preload("res://escenas/powerUpAgua.tscn")
var tierra_escena := preload("res://escenas/powerUpNaturaleza.tscn")
var fuego_escena := preload("res://escenas/powerUpFuego.tscn")

func _ready():
	# Al iniciar la escena, instancia y coloca cada power-up en una posición concreta
	spawn_powerup(agua_escena, Vector2(1000, 230))
	spawn_powerup(tierra_escena, Vector2(1000, 430))
	spawn_powerup(fuego_escena, Vector2(1000, 630))
	
# Función que instancia escena de power-up en una posición determinada
func spawn_powerup(escena: PackedScene, posicion: Vector2):
	var instancia = escena.instantiate()
	instancia.global_position = posicion
	add_child(instancia)
