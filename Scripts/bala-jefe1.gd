extends CharacterBody2D

@export var velocidad: float = 1500.0 # Movimiento horizontal izquierda
@onready var anima_bala = $AnimatedSprite2D #Variable para la animación
@onready var colision = $CollisionShape2D #Variable para la colisión
var muerto = false #Variable para verificar si pajaro está muerto
signal enemigo_muerto(puntos) #Señal personalizada llamada "enemigo_muerto" que se emite con los puntos cuando el enemigo muere.

func _ready():
	anima_bala.play("bala")#Da comienzo la animación de bala
	
func recibir_golpe():#Función para cuando bala recibe golpe
	if muerto: #Si le llega el disparo de personaje...
		return #Retorna
	muerto = true #Marco como verdadero el choque de bala
	colision.set_deferred("disabled", true)  # Desactiva colisión
	anima_bala.stop() #Se para la animación de bala
	anima_bala.play("puntos") #Da inicio la animación puntos
	$puntos.play()#Suena puntos
	emit_signal("enemigo_muerto", 90) #Emito la señal de que el enemigo ha muerto y sumo 90 puntos al marcador
	var tween = create_tween() # Crea un nuevo tween para desvanecer la animación de puntos
	tween.tween_property(anima_bala, "modulate:a", 0.0, 2.0)  #Programo el desvanecimiento de los puntos
	await tween.finished #Se espera a que termineel desvanecimiento
	queue_free() #Se elimina la bala de la escena

func _process(delta: float) -> void:# Función que utiliza automáticamente cada frame
	if muerto:#Si muerto es true...
		return #no ejecuta el movimiento
	position.x -= velocidad * delta#Si muerto es false la bala sigue una trayectoria en linea recta a la izquierda
