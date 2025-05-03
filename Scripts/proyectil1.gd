extends Area2D

@export var speed: float = 370.0  # Velocidad del proyectil
@export var direction: Vector2 = Vector2.RIGHT  # Dirección del disparo

func _ready():
	pass

func _physics_process(delta):
	position += direction * speed * delta  # Mueve el proyectil
	if position.x > get_viewport_rect().size.x or position.x < 0: # Se Destruye si sale de la pantalla (en el eje X)
		queue_free()  # Elimina proyectil

# Función para controlar colisiones
func _on_body_entered(body):
	if body.is_in_group("Enemigos"):  # Si impacta con un enemigo que esté en ese grupo
		body.recibir_golpe()  # Se llama aa la función recibir_golpe() en la rana
		queue_free()  # Destruye el proyectil
