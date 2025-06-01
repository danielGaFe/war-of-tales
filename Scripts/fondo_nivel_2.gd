extends ParallaxBackground

var scroll_speed := -2000.0 # Velocidad de desplazamiento horizontal (en píxeles por segundo)

func _process(delta):
	scroll_offset.x += scroll_speed * delta #Incrementa posición horizontal (scroll) en función del tiempo transcurrido y su velocidad
