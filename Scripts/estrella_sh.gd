extends CharacterBody2D #CharacterBody2D controla un personaje 2D, en este caso, una estrella de mar

@onready var anima_estrella = $estrella #Referencia al nodo Animatedsprite2D llamado "estrella".
@onready var colision = $CollisionShape2D #Referencia al nodo CollisionShape2D.
@export var velocidad: float = 190.0  # Velocidad a la que se mueve la estrella por la pantalla.
@export var amplitud_zigzag: float = 400.0  #amplitud de subida y bajada de la estrella
@export var frecuencia_zigzag: float = 2.0  #frecuencia de oscilación de la estrella
signal enemigo_muerto(puntos) #Señal personalizada llamada "enemigo_muerto" que se emite con los puntos cuando el enemigo muere.

var muerto = false #Variable para verificar si estrella está muerta
var tiempo := 0.0 #Variable de control de tiempo del movimiento de estrella
var posicion_inicial_y := 0.0 #Almacena la posición inicial de estrella

func _ready():
	anima_estrella.play("estrella") # Reproduce la animación llamada "estrella"
	posicion_inicial_y = position.y  #Almacena la altura
	
#Función apra cuando bala impacta sobre enemigo
func recibir_golpe():
	if muerto: #Si estrella ha muerto...
		return
	$puntos.play()
	muerto = true #Marco como verdadero la muerte de estrella 
	colision.set_deferred("disabled", true) #Desactiva la colisión
	anima_estrella.stop() #Se para la animación 
	anima_estrella.play("puntos") #Se reproduce la animación puntos
	emit_signal("enemigo_muerto", 90)#Emito la señal de que el enemigo ha muerto y sumo 90 puntos al marcador
	var tween = create_tween()# Crea un nuevo tween para desvanecer la animación de puntos
	tween.tween_property(anima_estrella, "modulate:a", 0.0, 2.0)#Programo el desvanecimiento de los puntos
	await tween.finished #Se espera a que termine el desvanecimiento
	queue_free() #Se elimina estrella de la escena

func _process(delta: float) -> void:
	if muerto:
		return
	#Programación del movimiento de la estrella en zigzag
	tiempo += delta #Aumento el tiempo en función del tiempo transcurrido.
	position.x -= velocidad * delta  # Muevo estrella hacia la izquierda a una velocidad constante.
	position.y = posicion_inicial_y + sin(tiempo * frecuencia_zigzag) * amplitud_zigzag # Se calcula la posición Y para el movimiento oscilatorio
