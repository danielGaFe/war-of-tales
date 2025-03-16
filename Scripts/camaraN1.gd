extends PathFollow2D

@export var speed: float = 100  # Velocidad de la cámara

func _process(delta):
	progress += speed * delta  # Mueve la cámara a lo largo del camino
