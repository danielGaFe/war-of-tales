extends CharacterBody2D #CharacterBody2D controla un personaje 2D, en este caso, un mosquito.

@onready var anima_mosquito = $mosquito #Referencia al nodo Animatedsprite2D llamado "mosquito".
@onready var colision = $CollisionShape2D #Referencia al nodo CollisionShape2D.
@export var velocidad: float = 700.0  # Velocidad a la que se mueve el mosquito por la pantalla.
@export var amplitud_zigzag: float = 200.0  #amplitud de subida y bajada del mosquito
@export var frecuencia_zigzag: float = 2.0  #frecuencia de oscilación del mosquito
signal enemigo_muerto(puntos) #Señal personalizada llamada "enemigo_muerto" que se emite con los puntos cuando el enemigo muere.

var muerto = false #Variable para verificar si mosquito está muerto
var tiempo := 0.0 #Variable de control de tiempo del movimiento de mosquito
var posicion_inicial_y := 0.0 #Almacena la posición inicial de mosquito

func _ready():
	anima_mosquito.play("mosquito") # Reproduce la animación llamada "mosquito"
	posicion_inicial_y = position.y  #Almacena la altura
	
#Función apra cuando bala impacta sobre enemigo
func recibir_golpe():
	if muerto: #Si mosquito ha muerto...
		return
	$puntos.play()
	muerto = true #Marco como verdadero la muerte de mosquito 
	colision.set_deferred("disabled", true) #Desactiva la colisión
	anima_mosquito.stop() #Se para la animación 
	anima_mosquito.play("puntos") #Se reproduce la animación puntos
	emit_signal("enemigo_muerto", 90)#Emito la señal de que el enemigo ha muerto y sumo 90 puntos al marcador
	var tween = create_tween()# Crea un nuevo tween para desvanecer la animación de puntos
	tween.tween_property(anima_mosquito, "modulate:a", 0.0, 2.0)#Programo el desvanecimiento de los puntos
	await tween.finished #Se espera a que termine el desvanecimiento
	queue_free() #Se elimina mosquito de la escena

func _process(delta: float) -> void:
	if muerto:
		return
	#Programación del movimiento del mosquito en zigzag
	tiempo += delta #Aumento el tiempo en función del tiempo transcurrido.
	position.x -= velocidad * delta  # Muevo al mosquito hacia la izquierda a una velocidad constante.
	position.y = posicion_inicial_y + sin(tiempo * frecuencia_zigzag) * amplitud_zigzag # Se calcula la posición Y para el movimiento oscilatorio
