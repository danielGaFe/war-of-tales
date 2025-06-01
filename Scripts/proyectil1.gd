extends Area2D

@export var speed: float = 370.0  # Velocidad del proyectil
@export var direction: Vector2 = Vector2.RIGHT  # Dirección del disparo

func _ready():
	pass

func _physics_process(delta):
	position += direction * speed * delta  # Mueve el proyectil


# Función para controlar colisiones
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemigos") or body.is_in_group("ColisionSinDaño"):
		if body.has_method("recibir_golpe"):
			body.call_deferred("recibir_golpe")  # LLAMADA DIFERIDA para evitar modificar colisiones en medio del frame
		call_deferred("queue_free")  # Eliminar el proyectil aplazado
