extends Node2D

@export var direction: Vector2 = Vector2.ZERO # Dirección del disparo fija
@onready var anima_bala = $AnimationPlayer  # Referencia al nodo AnimationPlayer del proyectil

func _ready():
	anima_bala.play("bala_naturaleza")  # Reproduce la animación bala_naturaleza
	await get_tree().create_timer(0.3).timeout #Se queda visible durante 0.3 segundos
	queue_free()#Desaparece animación
	
# Función para manejar colisiones
func _on_body_entered(body):
	if body.is_in_group("Enemigos"):  # Si bala impacta con un enemigo
		body.recibir_golpe()  # Llama a la función recibir_golpe() en el enemigo
		queue_free()  # Destruye el proyectil
