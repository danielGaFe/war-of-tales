extends ParallaxBackground

func _process(delta):
	scroll_offset.x += -5000 * delta # Desplaza el fondo hacia la izquierda a una velocidad de 5000 píxeles por segundo.
