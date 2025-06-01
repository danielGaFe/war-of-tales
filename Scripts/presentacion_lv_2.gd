extends Control

@onready var anima_lv1 = $AnimationPlayer #Referencia a animationplayer
@onready var timer = $Timer #Referencia a Timer


func _ready():
	timer.timeout.connect(_on_timeout)# Conecta la señal 'timeout' del temporizador a la función _on_timeout
	anima_lv1.play("lv1")  # Reproduce la animación

func _on_timeout():
	get_tree().change_scene_to_file("res://escenas/N3.tscn") # Cambia la escena
