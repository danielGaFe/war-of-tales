extends CanvasLayer

@onready var anima_vida = $AnimaVida  # Variable para controlar la animacion
func _ready():
	anima_vida.play("vidas")  # Reproduce la animación del ícono de "vidas"
