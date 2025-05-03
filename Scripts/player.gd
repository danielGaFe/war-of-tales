extends CharacterBody2D

enum TipoDisparo { DISPARO1, DISPARO2, DISPARO3 }  # Define tres constantes: DISPARO1 = 0 (Bala de agua), DISPARO2 = 2 (Bala flor), DISPARO3 = 2 (bala fuego)
var disparo_activo = TipoDisparo.DISPARO1 #Define el disparo actual

@export var Proyectil1: PackedScene = preload("res://escenas/Proyectil1.tscn") #Referencia a la escena del proyectil1
@export var Proyectil2: PackedScene = preload("res://escenas/Proyectil2.tscn") #Referencia a la escena del proyectil2
@export var Proyectil3: PackedScene = preload("res://escenas/Proyectil3.tscn") #Referencia a la escena del proyectil3
@onready var anima_player = $AnimatedSprite2D #Referencia al nodo AnimatedSprite2D que contiene las animaciones de Player
@onready var area_colision = $Area2D  #Nodo de colisión del personaje
@onready var visible_notificador = $VisibleOnScreenNotifier2D # Nodo para detectar si el player se sale de pantalla
@onready var vidas_nodo = $Vidas # Nodo para gestionar las vidas del jugador
@export var velocidad: float = 200.0 #Velocidad de movimiento horizontal
@export var salto: float = -400.0 #Fuerza del salto
@export var gravedad: float = 980.0  #Fuerza de la gravedad

#Variables para el parpadeo de Player al perder vida
var tiempo_parpadeo 
var tiempo_transcurrido
var esta_parpadeando = false
@onready var parpadeo_muerte = $Timer

func _ready():
	anima_player.play("idle-normal") # Reproduce animación inicial de personaje quieto (idle)
	SenalGlobal.connect("powerup_recogido", Callable(self, "_on_powerup_recogido")) # Conecta la señal global de recoger un power-up
	area_colision.connect("body_entered", Callable(self, "_on_body_entered"))  # Conecta la señal de colisión con enemigos
	visible_notificador.connect("screen_exited", Callable(self, "_on_screen_exited")) #identifica si el jugador sale de la cámara
	parpadeo_muerte.connect("timeout", Callable(self, "_on_func_parpadeo_muerte_timeout"))  #Conecta timeout de timer con el método de parpadeo

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravedad * delta #Aplica la gravedad si player no está en el suelo

	# Movimiento horizontal
	var direction = Input.get_axis("ui_left", "ui_right") #Lee la dirección que está pulsando el jugador
	if direction != 0: #Si dirección es diferente a 0...
		velocity.x = direction * velocidad #Player se mueve a la direcci´çon correspondiente.
		cambiar_animacion(true)  # Player cambia su animación
		anima_player.flip_h = direction < 0 #voltea Player si jugador va hacía la izquierda.
	else: #De lo contrario...
		var desaceleracion = 500.0 #Establezco la velocidad de desaceleración
		velocity.x = move_toward(velocity.x, 0, desaceleracion * delta) #Detiene lentramente el movimiento de player.
		cambiar_animacion(false)  #Vuelve a la animación IDLE

	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = salto #Programación de salto si player está en el suelo.

	# Disparo
	if Input.is_action_just_pressed("Disparo1"):
		Disparo1() #Ejecuta la función de disparo

	# Mueve el personaje
	move_and_slide()

# Función para cambiar las animaciones según el estado y tipo de disparo
func cambiar_animacion(esta_caminando: bool):
	if disparo_activo == TipoDisparo.DISPARO1: #Si disparo activo es igual a disparo1...
		if esta_caminando: #Si player está caminando y...
			if anima_player.animation != "camina-normal": #Si tiene una animación distinta a camina-normal...
				anima_player.play("camina-normal") #Se cambia la animación a camina-normal
		else: #Por el contrarío si player está parado y...
			if anima_player.animation != "idle-normal": #Si tiene una animación distinta a idle-normal...
				anima_player.play("idle-normal") #Se cambia la animación a idle-normal
				
	elif disparo_activo == TipoDisparo.DISPARO2:#Si disparo activo es igual a disparo2...
		if esta_caminando: #Si player está caminando y...
			if anima_player.animation != "camina-tierra": #Tiene una animación distinta a camina-tierra...
				anima_player.play("camina-tierra") #Se cambia la animación a camina-tierra
		else: #Por el contrarío si player está parado y...
			if anima_player.animation != "idle-tierra": #Si tiene una animación distinta a idle-tierra...
				anima_player.play("idle-tierra") #Se cambia la animación a idle-tierra
				
	elif disparo_activo == TipoDisparo.DISPARO3:#Si disparo activo es igual a disparo3...
		if esta_caminando: #Si player está caminando y...
			if anima_player.animation != "camina-fuego": #Si tiene una animación distinta a camina-fuego...
				anima_player.play("camina-fuego") #Se cambia la animación a camina-fuego
		else: #Por el contrarío si player está parado y...
			if anima_player.animation != "idle-fuego": #Si tiene una animación distinta a idle-fuego...
				anima_player.play("idle-fuego") #Se cambia la animación a idle-fuego

# Función para niciar el parpadeo cuando el jugador recibe daño
func func_parpadeo_muerte():
	tiempo_parpadeo = 2.0 # Duración del efecto de parpadeo
	tiempo_transcurrido = 0.0 #tiempo transcurrido
	esta_parpadeando = true #Variable para establecer que player está parpadenando
	parpadeo_muerte.start() #Inicia el timer

#Función para alternar la visibilidad del parpadeo en Player.
func _on_func_parpadeo_muerte_timeout():
	if esta_parpadeando:
		anima_player.visible = not anima_player.visible #Alterna la visibilidad del sprite
		tiempo_transcurrido += parpadeo_muerte.wait_time 
		if tiempo_transcurrido >= tiempo_parpadeo: #Si tiempo transcurrido es mayor o igual que tiempo de parpadeo activo...
			esta_parpadeando = false #Da por finalizado el parpadeo
			anima_player.visible = true # Establede la visibilidad total de player
		else: #De lo contrario
			parpadeo_muerte.start() #Repite el parpadeo.

# Lógica de disparo
func Disparo1():
	var bullet: Node2D #Nodo del proyectil
	var offset_x = 30 # Posición horizontal respecto a Player
	var offset_y = -5 #Posición vertical respecto a player.

	match disparo_activo: #Detecta el tipo de disparo actual
		TipoDisparo.DISPARO1: #Si tipo de disparo es el 1 (Agua)
			bullet = Proyectil1.instantiate() #Instancia proyectil1
			if anima_player.flip_h: #Si personaje esta mirando a la izquierda cuando dispara... 
				offset_x = -offset_x #Invierte el desplazamiento de disparo
				bullet.direction = Vector2.LEFT
				bullet.get_node("BALA1").flip_h = true
			else: #	Si player está mirando a la derecha cuando dispara...
				bullet.direction = Vector2.RIGHT #Proyectil se mueve a la derecha
			bullet.position = position + Vector2(offset_x, offset_y) #Coloca proyectil en la posición del personaje con el offset definido.
			
			
		TipoDisparo.DISPARO2: #Si tipo de disparo es el 2 (flor)
			bullet = Proyectil2.instantiate() #Instancia proyectil2
			bullet.direction = Vector2.ZERO #disparo no se mueve
			bullet.position = Vector2(0, -10) #Coloca el proyectil en una zona fija
			add_child(bullet) #Añade proyectil como hijo del personaje por lo que se puede mover junto a él.
			return
			
		TipoDisparo.DISPARO3: #Si tipo de disparo es el 3 (fuego)
			bullet = Proyectil3.instantiate() #Instancia proyectil3
			if anima_player.flip_h:  #Si personaje está mirando a la izquierda cuando dispara... 
				offset_x = -offset_x #Invierte el desplazamiento de disparo
				bullet.direction = Vector2.LEFT
				bullet.position = Vector2(130, -5)
				bullet.get_node("BALA1").flip_h = true
			else: #	Si player está mirando a la derecha cuando dispara...
				bullet.direction = Vector2.RIGHT #Proyectil se mueve a la derecha
			bullet.position = position + Vector2(offset_x, offset_y) #Coloca proyectil en la posición del personaje con el offset definido.
			
		_:
			return
#Si el disparo no coincide con ninguno muestra error y finaliza la función.
	if bullet:
		get_parent().add_child(bullet)
	else:
		print("Error: Proyectil no asignado.")
		
# Cambio de tipo de disparo al colisionar con un power-up
func _on_powerup_recogido(tipo):
	match tipo:
		"disparo1":
			disparo_activo = TipoDisparo.DISPARO1
			cambiar_animacion(false)
		"disparo2":
			disparo_activo = TipoDisparo.DISPARO2
			cambiar_animacion(false)
		"disparo3":
			disparo_activo = TipoDisparo.DISPARO3
			cambiar_animacion(false)
		_:
			print("Power-up desconocido:", tipo)

# Función que se llama cuando el jugador es golpeado por un enemigo
func _on_hit_by_enemy():
	vidas_nodo.perder_vida()  # Llama al método para restar vidas
	func_parpadeo_muerte() #Llama a la función parpadeo muerte
	
# Función que se llama cuando el jugador entra en contacto con un enemigo
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemigos"):  # Verifica si el cuerpo que tocó es un enemigo mediante su correspondiente grupo
		_on_hit_by_enemy()  # Resta vida al jugador

# Función que se llama cuando el jugador sale de la cámara
func _on_screen_exited():
	vidas_nodo.perder_vida()  # Llama al método para restar una vida cuando el jugador sale de la pantalla
	
