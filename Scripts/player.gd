extends CharacterBody2D


@onready var anima_player = $AnimationPlayer  # Creo la variable anima_player

func _ready():
	anima_player.play("IDLE")  # Reproduce la animación "IDLE"
