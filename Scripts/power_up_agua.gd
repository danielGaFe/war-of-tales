extends Area2D

@export var tipo_powerup: String = "disparo1" #Variable exportada que cambia el disparo al recoger este power-up
@onready var anima_pw_agua = $AnimaPWagua #Referencia al nodo AnimaPWagua

func _ready():
	anima_pw_agua.play("PWagua") #Inicia la animación PWagua
	connect("body_entered", Callable(self, "_on_body_entered")) # Conecta la señal 'body_entered' a _on_body_entered para detectar colisiones.

func _on_body_entered(body):
	if body is CharacterBody2D: # Verifica si el cuerpo que entró en contacto es un personaje (jugador).
		SenalGlobal.emitir_powerup(tipo_powerup) # Emite la señal powerup_recogido a SenalGlobal
		queue_free()  # Elimina el power-up de la escena cuando ha sido recogido.
