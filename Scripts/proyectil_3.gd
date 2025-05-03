extends Area2D

@export var speed: float = 370.0  # Velocidad del proyectil
@export var direction: Vector2 = Vector2.RIGHT  # Dirección del disparo
@onready var anima_bala = $AnimationPlayer  # Referencia al nodo AnimationPlayer del proyectil

func _ready():
	pass
	anima_bala.play("disparo-fuego") #Ejecuta la animación disparo-fuego

func _physics_process(delta):
	position += direction * speed * delta  # Mueve el proyectil
	if position.x > get_viewport_rect().size.x or position.x < 0: 	# Destruye el proyectil si sale de la pantalla 
		queue_free()  # Elimina el proyectil

# Función para manejar colisiones
func _on_body_entered(body):
	if body.is_in_group("Enemigos"):  # Si impacta con un enemigo del grupo Enemigos
		body.recibir_golpe()  # Llama aa la función recibir_golpe()
		queue_free()  # Destruye el proyectil
