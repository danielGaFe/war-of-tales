extends CharacterBody2D

@onready var anima_hoja = $AnimaHoja  # Variable para controlar las animaciones
func _ready():
	anima_hoja.play("hoja")  # Reproduce la animación "IDLE"
