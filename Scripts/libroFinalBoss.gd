extends Area2D

@onready var anima_libro = $AnimatedSprite2D

func _ready() -> void:
	anima_libro.play("finalBoss")
	connect("body_entered", Callable(self, "_on_body_entered"))
	$sonido.play()

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Solo actúa si el cuerpo está en el grupo "player"
			print("Game Over")
			SenalGlobal.puntos_para_ranking = SenalGlobal.puntos  # Guardamos puntos para usarlos en la escena ranking
			get_tree().change_scene_to_file("res://escenas/ranking.tscn")
