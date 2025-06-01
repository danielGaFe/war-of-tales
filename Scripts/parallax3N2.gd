extends ParallaxBackground

func _process(delta):
	scroll_offset.x += -450 * delta # Desplaza el fondo hacia la izquierda a una velocidad de 450 píxeles por segundo.
