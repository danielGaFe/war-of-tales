extends CharacterBody2D

@onready var sprite_pez = $Pez# Referencia al Sprite2D del pez
@onready var anim_player = $Pez/AnimationPlayer# Referencia al Sprite2D dentro del Sprite
@onready var colision = $CollisionShape2D#CollisionShape2D del personaje
@onready var sonido_puntos = $puntos#Nodo de sonido (AudioStreamPlayer)
@onready var puntos_anim = $AnimatedSprite2D#AnimatedSprite2D para puntos

signal enemigo_muerto(puntos)# Señal personalizada
var muerto = false# Estado de muerte

func _ready():
	anim_player.play("pez1")# Comienza la animación normal
	puntos_anim.visible = false# Asegura que los puntos estén ocultos al inicio
	puntos_anim.modulate.a = 1.0# Asegura que la opacidad esté completa

func recibir_golpe():
	if muerto:#Si está muerto no hacer nada
		return
	muerto = true#de lo contrario marcamos muerto como verdadero
	colision.set_deferred("disabled", true)
	anim_player.stop()

	# Reproduce puntos
	puntos_anim.visible = true
	puntos_anim.play("puntos")
	sonido_puntos.play()
	emit_signal("enemigo_muerto", 50)

	# Efecto flotante de puntos
	var puntos_tween = create_tween()
	puntos_tween.tween_property(puntos_anim, "position:y", puntos_anim.position.y - 20, 1.0)
	puntos_tween.tween_property(puntos_anim, "modulate:a", 0.0, 1.0)

	# Desvanece al pez
	var tween = create_tween()
	tween.tween_property(sprite_pez, "modulate:a", 0.0, 2.0)
	await tween.finished
	queue_free()
