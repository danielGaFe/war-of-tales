extends Node2D

@onready var anima_lv1 = $AnimationPlayer  # Variable para controlar las animaciones
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(_on_timeout)
	anima_lv1.play("lv1")  # Reproduce la animación "lv1"

func _on_timeout():
	get_tree().change_scene_to_file("res://escenas/N1.tscn") #Carga la escena N1
