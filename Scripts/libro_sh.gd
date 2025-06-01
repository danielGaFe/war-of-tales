extends CharacterBody2D

@onready var anima_libro = $AnimatedSprite2D#Referencia a la animación del libro

#Escenas precargadas desde el editor de Godot son las hojas de poderes
@export var agua: PackedScene
@export var fuego: PackedScene
@export var tierra: PackedScene

var velocidad := Vector2(-300, 0)# Velocidad de movimiento horizontal (el libro se mueve hacia la izquierda)
var roto = false# Variable de control de rotura del libro

func _ready():
	randomize()#los valores aleatorios cambian aleatoriamente
	anima_libro.play("book")# Inicia la animación del libro

func recibir_golpe():
	if roto:# Si libro está roto no hacemos nada
		return
	roto = true # Si nio está roto marcamos que ya está roto
	var escenas = [agua, fuego, tierra]# Lista con las tres escenas posibles a instanciar
	var aleatoria = escenas[randi() % escenas.size()]# Selección aleatoria de una de las escenas
	if aleatoria:# Si se ha seleccionado correctamente una escena
		var instancia = aleatoria.instantiate()# Instancia la escena aleatoria
		get_parent().add_child(instancia)# La añade al mismo nodo padre que el libro
		instancia.global_position = global_position # Coloca la hoja en la misma posición del libro
	if has_node("Area2D"):# Desactiva el área de colisión para evitar colisiones después de roto
		$Area2D.set_deferred("monitoring", false)
	if $CollisionShape2D:
		$CollisionShape2D.set_deferred("disabled", true)
	call_deferred("queue_free")	# Elimina el libro de forma segura en el siguiente frame

func _on_area_entered(area):# Función que se ejecuta cuando otra área entra en contacto con el libro
	if area.is_in_group("disparo"):# Si la otra área pertenece al grupo "disparo"
		call_deferred("recibir_golpe")# Llama a la función para romper el libro

func _process(delta):# Movimiento automático del libro en cada frame
	position += velocidad * delta# Mueve el libro a la izquierda cada frame
