extends CharacterBody2D

@onready var anima_arbol = $AnimaArbol  # Variable para controlar la animacion
func _ready():
	anima_arbol.play("arbol")  # Reproduce la animación "arbol"
