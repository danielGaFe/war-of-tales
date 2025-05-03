extends CharacterBody2D

@onready var anima_arbol = $AnimaPlanta  # Variable para controlar la animación
func _ready():
	anima_arbol.play("plantaTrepadora")  # Reproduce la animación 
