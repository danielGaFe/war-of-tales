extends ParallaxBackground

func _process(delta):
	scroll_offset.x += -500 * delta # Desplaza el fondo hacia la izquierda a una velocidad de 500 píxeles por segundo.
