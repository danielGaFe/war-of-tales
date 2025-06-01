#Script para el enemigo cangrejo
extends CharacterBody2D

@onready var anima_cangrejo = $cangrejoanima  #Referencia a la nimación del cangrejo
@onready var colision = $CollisionShape2D #Referencia a la colisión del cangrejo
@export var velocidad: float = 100.0 #Velocidad de desplazamiento de cangrejo
@export var limite_izquierdo: float = 100.0 # ímite izquierdo del recorrido que hace el cangrejo
@export var limite_derecho: float = 500.0 #Límite derecho del recorrido que hace el cangrejo
@export var rango: float = 200.0 #Rango de movimiento total desde la posición inicial

var direccion: int = -1  #Movimiento hacia la izquierda
var muerto = false #Variable booleana para controlar el estado de cangrejo
signal enemigo_muerto(puntos) #Señal para poder sumar puntos al marcador

func _ready():
	limite_izquierdo = position.x - rango  #Calculo el límite izquierdo desde la posición inicial
	limite_derecho = position.x + rango #Calculo el límite derecho desde la posición inicial
	anima_cangrejo.play("cangrejos") #Reproduzco la animación

func recibir_golpe():#Función que se llama cuando el cangrejo recibe un proyectil
	if muerto:# Si ha muerto, no hago nada
		return
	muerto = true# Si está vivo marcamos la variable boolean como true
	colision.set_deferred("disabled", true)#Deshabilito la colisión
	anima_cangrejo.stop()#Pauso la animación
	anima_cangrejo.play("puntos")#comienza animación de puntos
	$puntos.play()#Reproduce sonido de puntos
	emit_signal("enemigo_muerto", 90)#Emito señal de que el enemigo ha muerto y se sumo 90 puntos al marcador
	var tween = create_tween()#Creo tween para suavizar animación.
	tween.tween_property(anima_cangrejo, "modulate:a", 0.0, 2.0)# Cambio la opacidad del sprite hasta 0 en 2 segundos
	await tween.finished #Espero a finalizar tween
	queue_free()#Elimino nodo árbol

func _process(delta: float) -> void:
	if muerto:# Si ha muerto, no hago nada
		return
	position.x += direccion * velocidad * delta# Muevo al cangrejo en la dirección actual a la velocidad indicada en la variable global
	if position.x < limite_izquierdo: #Si el límite  izquierdo es menor que posicionX
		direccion = 1 #Cambio de dirección a la derecha
	elif position.x > limite_derecho:#Si el límite  derecho es mayor que posicionX
		direccion = -1 #Cambio de dirección a la  izquierda
