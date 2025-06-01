extends CharacterBody2D

@onready var anima_rayo = $AnimaRayo
@onready var area = $Area2D

func _ready():
	anima_rayo.play("rayo")
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Llamada a la función de parpadeo en el jugador
		body.func_parpadeo_muerte()

		# Lógica para restar una vida
		var vidas_nodes = get_tree().get_nodes_in_group("Vidas")
		if vidas_nodes.size() > 0:
			vidas_nodes[0].perder_vida()
