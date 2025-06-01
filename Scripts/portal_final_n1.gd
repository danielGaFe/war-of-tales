extends Area2D

@onready var anima_libro = $AnimatedSprite2D

func _ready() -> void:
	anima_libro.play("finalBoss")# Inicia la animación llamada "finalBoss"
	connect("body_entered", Callable(self, "_on_body_entered"))# Conecta la señal de colisión con el cuerpo 
	$sonido.play()# Reproduce el sonido al iniciar la escena

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Solo actúa si el cuerpo está en el grupo "player"
		get_tree().change_scene_to_file("res://escenas/nivel_2.tscn")#Abre la escena 
