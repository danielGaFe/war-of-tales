extends CharacterBody2D

@onready var anima_corazon = $AnimaCorazon  # Variable para controlar las animaciones
func _ready():
	anima_corazon.play("corazon")  # Reproduce la animación "IDLE"
