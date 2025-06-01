extends CharacterBody2D

@onready var anima_plataforma = $AnimationPlayer #Referencia a AnimationPlayer 
@onready var area = $Area2D  #Referencia a Area2D para detectar si player entra en contacto.
@onready var collision_shape = $CollisionShape2D  # Referencia a CollisionShape2D, establece la colisión de la plataforma.

func _ready():
	area.body_entered.connect(_on_body_entered) # Conecta la señal de "cuerpo entró" de Area2D a _on_body_entered
	anima_plataforma.animation_finished.connect(_on_animation_finished)  # Conecta la señal cuando termina la animación

func _on_body_entered(body):
	if body.is_in_group("Player"): # Comprueba si el cuerpo que ha entrado en contacto es del grupo "Player".
		anima_plataforma.play("new_animation")  # Inicia la animación

func _on_animation_finished(anim_name):
	if anim_name == "new_animation": # Si la animación finalizada es igual a "new_animation"...
		collision_shape.disabled = true  # Se desactiva las colisiones
