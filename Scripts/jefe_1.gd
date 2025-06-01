extends CharacterBody2D

@onready var anima_jefe1 = $AnimatedSprite2D #Controla animación de jefe
@onready var colision = $CollisionShape2D  # Cuerpo general 
@onready var audio_player = $AudioStreamPlayer2D# Reproduce el sonido del jefe
@export var golpes_necesarios: int = 30#Cantidad de disparos necesarios para matar al jefe

var golpes_actuales: int = 0# Contador de los golpes actuales recibidos
var muerto = false# Indica si el jefe ha muerto o no
signal enemigo_muerto(puntos) # Señal que emite al morir, para pasar los puntos obtenidos

# Levitación
var amplitud := 200.0#Amplitud de la oscilación vertical
var velocidad := 4.0# Velocidad de oscilación
var base_y := 300.0# Posición Y de referencia
var tiempo := 0.0# Tiempo acumulado para el calculo de la oscilación


@onready var temporizador: Timer = $Timer# Temporizador para disparar balas
@onready var punto_bala = $Marker2D# Punto desde el que salen las balas
@export var bullet_scene: PackedScene# Escena que se usa para instanciar las balas

func _ready():
	anima_jefe1.play("JEFE1") #Inicializa la animación principal
	temporizador.wait_time = 2.0 # Espera 2 segundos entre disparos
	temporizador.one_shot = false# El temporizador se repite
	if not temporizador.is_connected("timeout", Callable(self, "_on_shoot_timer_timeout")):
		temporizador.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))
	temporizador.start()# Inicia el temporizador
	if audio_player.stream:
		audio_player.stream.loop = true   # Hace que el sonido se repita en bucle
		audio_player.play()# Comienza a reproducir el sonido

func _on_shoot_timer_timeout():
	disparo()# Llama a la función de disparo

func disparo():
	var bullet = bullet_scene.instantiate()# Instancia una nueva bala
	bullet.global_position = punto_bala.global_position # Posiciona la bala en el punto de disparo
	get_tree().current_scene.add_child(bullet)# Añade la bala a la escena actual
	bullet.velocidad = 1500.0 # Asigna la velocidad de la bala
	var marcador = get_tree().root.get_node("NIVEL2") # Busca el nodo que lleva la puntuación
	bullet.connect("enemigo_muerto", Callable(marcador, "_on_enemigo_muerto"))# Conecta la señal de enemigo muerto con el marcador
	
func _process(delta):
	tiempo += delta# Acumula tiempo
	position.y = base_y + sin(tiempo * velocidad) * amplitud # Aplico la formula del movimiento senoidal

# Detección de colisiones
func _on_area_2d_body_entered(body: Node2D) -> void:
	if muerto:#Si ya está muerto, no hace nada
		return
	if body.name == "BALA1":
		body.queue_free()# Elimina la bala que lo golpeó
		recibir_golpe()# Aplica la función recibir golpe

func recibir_golpe():
	if muerto: # Si ya está muerto, ignora el golpe
		return
	$gruñe.play() # Reproduce sonido de daño
	golpes_actuales += 1# Incrementa 1 el contador de golpes recibidos
	anima_jefe1.stop()# Detiene la animación actual
	anima_jefe1.play("JEFE1_DAÑO")# Muestra animación de recibir daño
	await anima_jefe1.animation_finished#Espero a que termine la animación de daño

	if golpes_actuales >= golpes_necesarios:
		muerto = true# Si llega al número de golpes necesarios:
		$muere.play() # Reproduce sonido de muerte
		colision.set_deferred("disabled", true)# Desactivo las colisiones
		anima_jefe1.play("puntos")# Muestra animación de puntos
		emit_signal("enemigo_muerto", 90) # Emite señal con 90 puntos
		var tween = create_tween()# Crea un tween para animar la desaparición
		tween.tween_property(anima_jefe1, "modulate:a", 0.0, 2.0) # Hace que desaparezca lentamente (fade out)
		await tween.finished #Espera a que acabe.
		queue_free()# Elimina al jefe de la escena
		var escena_portal = load("res://escenas/Portal_final_Castillo.tscn")# Carga el portal que lleva al siguiente nivel
		var instancia_portal = escena_portal.instantiate()# Instancia el portal
		instancia_portal.global_position = global_position   # Lo posiciona donde estaba el jefe
		get_tree().current_scene.add_child(instancia_portal)# Lo muestra en la escena
	else:
		anima_jefe1.play("JEFE1")# Si no ha muerto, vuelve a la animación normal
