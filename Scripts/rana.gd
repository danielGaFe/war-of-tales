extends CharacterBody2D

@onready var anima_rana = $Rana #Referencia al nodo Animatedsprite2D llamado "Rana".
@onready var colision = $CollisionShape2D #Referencia al nodo CollisionShape2D.
signal enemigo_muerto(puntos)  #Señal personalizada llamada "enemigo_muerto" que se emite con los puntos cuando el enemigo muere.
var muerto = false #Variable para verificar si rana está muerta

func _ready():
	anima_rana.play("rana")  # Animación rana

func recibir_golpe():
	if muerto:
		return
	muerto = true #Marco como true la muerte de rana
	colision.set_deferred("disabled", true)  # Desactiva colisión
	anima_rana.stop() #Paro la animaciuón de rana
	$puntos.play()
	anima_rana.play("puntos") #Da comienzo la animación de puntos
	emit_signal("enemigo_muerto", 50) #Sumo 50 puntos al marcador
	var tween = create_tween() 	# Creo tween para desvanecer puntos
	tween.tween_property(anima_rana, "modulate:a", 0.0, 2.0)  # De opacidad 1 a 0 en 1 segundo
	await tween.finished #Se espera a que termine el desvanecimiento
	queue_free() #Se elimina rana de la escena
