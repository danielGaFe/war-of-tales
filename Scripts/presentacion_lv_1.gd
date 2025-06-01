extends Control

@onready var anima_lv1 = $AnimationPlayer #Referencia a animationplayer
@onready var timer = $Timer #Referencia a Timer


func _ready():
	timer.timeout.connect(_on_timeout) # Conecta la señal 'timeout' del temporizador a la función _on_timeout
	anima_lv1.play("lv1")   # Reproduce la animación

func _on_timeout():
	SenalGlobal.puntos = 0# Reinicia los puntos globales a 0
	SenalGlobal.vidas = 3# Reinicia las vidas globales a 3
	get_tree().change_scene_to_file("res://escenas/N1.tscn")# Cambia la escena
