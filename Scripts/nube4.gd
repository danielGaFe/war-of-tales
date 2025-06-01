extends CharacterBody2D

@onready var anima_plataforma = $AnimationPlayer #Referencia al nodo AnimationPlayer 
@onready var area = $Area2D  #Referencia al nodo Area2D usado para detectar cuándo el jugador entra en contacto.
@onready var collision_shape = $CollisionShape2D  # Referencia al nodo CollisionShape2D, define la colisión de la plataforma.

func _ready():
	area.body_entered.connect(_on_body_entered) # Conecta la señal de "cuerpo entró" del Area2D a la función _on_body_entered.
	anima_plataforma.animation_finished.connect(_on_animation_finished)  # Conecta la señal cuando termina la animación

func _on_body_entered(body):
	if body.is_in_group("Player"): # Comprueba si el cuerpo que entró pertenece al grupo "Player".
		anima_plataforma.play("Nube4")  # Inicia la animación

func _on_animation_finished(anim_name):
	if anim_name == "Nube4": # Si la animación finalizada es igual a "nube_plataforma".
		collision_shape.disabled = true  # Desactiva el CollisionShape2D
