extends Node2D

@export var direction: Vector2 = Vector2.ZERO # Dirección del disparo fija
@onready var anima_bala = $AnimationPlayer  # Referencia al nodo AnimationPlayer del proyectil

func _ready():
	anima_bala.play("bala_naturaleza")  # Reproduce la animación bala_naturaleza
	await get_tree().create_timer(0.3).timeout #Se queda visible durante 0.3 segundos
	call_deferred("queue_free")#Desaparece animación
	
# Función para manejar colisiones
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemigos") or body.is_in_group("ColisionSinDaño"):
		if body.has_method("recibir_golpe"):
			body.call_deferred("recibir_golpe")  # LLAMADA DIFERIDA para evitar modificar colisiones en medio del frame
		call_deferred("queue_free")  # Eliminar el proyectil aplazado
