extends CharacterBody2D

@onready var anima_pajaro = $pajaro  #Referencia al nodo Animatedsprite2D llamado "pajaro".
@onready var colision = $CollisionShape2D #Referencia al nodo CollisionShape2D.
@export var velocidad: float = 100.0 # Velocidad a la que se mueve el pajaro por la pantalla.
var muerto = false #Variable para verificar si pajaro está muerto
signal enemigo_muerto(puntos) #Señal personalizada llamada "enemigo_muerto" que se emite con los puntos cuando el enemigo muere.


func _ready():
	anima_pajaro.play("volando")  #Da inicio la animación volando

#Función apra cuando bala impacta sobre enemigo
func recibir_golpe():
	if muerto:
		return
	muerto = true #Marco como verdadero la muerte del pajaro
	colision.set_deferred("disabled", true)  # Desactiva colisión
	anima_pajaro.stop() #Se para la animación de pajaro
	anima_pajaro.play("puntos") #Da inicio la animación puntos
	emit_signal("enemigo_muerto", 90) #Emito la señal de que el enemigo ha muerto y sumo 90 puntos al marcador
	var tween = create_tween() # Crea un nuevo tween para desvanecer la animación de puntos
	tween.tween_property(anima_pajaro, "modulate:a", 0.0, 2.0)  #Programo el desvanecimiento de los puntos
	await tween.finished #Se espera a que termineel desvanecimiento
	queue_free() #Se elimina pajaro de la escena

func _process(delta: float) -> void:
	if muerto:
		return  # Si está "muerto", no se mueve
	position.x -= velocidad * delta  # Movimiento hacia la izquierda
