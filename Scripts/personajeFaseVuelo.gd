extends CharacterBody2D

enum TipoDisparo { DISPARO1, DISPARO2, DISPARO3 }  # Define tres constantes: DISPARO1 = 0 (Bala de agua), DISPARO2 = 2 (Bala flor), DISPARO3 = 2 (bala fuego)
var disparo_activo = TipoDisparo.DISPARO1 #Define el disparo actual

@export var Proyectil1: PackedScene = preload("res://escenas/Proyectil1vuelo.tscn") #Referencia a la escena del proyectil1
@export var Proyectil2: PackedScene = preload("res://escenas/Proyectil2.tscn") #Referencia a la escena del proyectil2
@export var Proyectil3: PackedScene = preload("res://escenas/Proyectil3vuelo.tscn") #Referencia a la escena del proyectil3
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
var libre_movimiento := false
var tiempo_libre := 5.0
@onready var temporizador_retorno := Timer.new()


func _ready():
	anima_player.play("vuela_agua") # Reproduce animación inicial de personaje quieto (idle)
	disparo_activo = TipoDisparo.DISPARO1
	await get_tree().process_frame  # Espera un frame
	SenalGlobal.connect("powerup_recogido", Callable(self, "_on_powerup_recogido")) # Conecta la señal global de recoger un power-up
	area_colision.connect("body_entered", Callable(self, "_on_body_entered"))  # Conecta la señal de colisión con enemigos
	visible_notificador.connect("screen_exited", Callable(self, "_on_screen_exited")) #identifica si el jugador sale de la cámara
	parpadeo_muerte.connect("timeout", Callable(self, "_on_func_parpadeo_muerte_timeout"))  #Conecta timeout de timer con el método de parpadeo
	add_child(temporizador_retorno)#Añado el temporizador como hijo del nodo actual
	temporizador_retorno.one_shot = true#Configuro temporizador para que dispare solo una vez y luego se detenga automáticamente.
	temporizador_retorno.wait_time = tiempo_libre# Establece el tiempo de espera (en segundos) antes de que se dispare el temporizador.
	temporizador_retorno.timeout.connect(_on_tiempo_libre_finalizado)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo.

var en_el_aire = not is_on_floor()

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")# Obtiene vector de dirección en función de las teclas de movimiento pulsadas.
	velocity = direction.normalized() * velocidad# Normaliza el vector de direcciónde longitud 1 y lo multiplica por la velocidad deseada.
	if Input.is_action_just_pressed("Disparo1"):# Si se presiona la tecla de disparo, se llama a la función...
			Disparo1()#Disparo
	if direction != Vector2.ZERO:# Si se está moviendo horizontalmente, voltea el sprite según la dirección.
		anima_player.flip_h = direction.x < 0
		cambiar_animacion(true)# Activa la animación de movimiento.
	else:
		cambiar_animacion(false)# Si no hay movimiento, activa la animación de reposo o idle.
	move_and_slide()# Mueve el personaje.


# Función para cambiar las animaciones según el estado y tipo de disparo
func cambiar_animacion(esta_caminando: bool):
	if libre_movimiento:
		if anima_player.animation != "fuera_camara":
			anima_player.stop()  # Detene animación
			anima_player.play("fuera_camara")  # Cambiar a la animación fuera_camara
		return  # Sale de la función para no seguir con el resto de animaciones

	# Si disparo activo es igual a disparo1 se cambia a animación vuela_agua...
	if disparo_activo == TipoDisparo.DISPARO1:
		if esta_caminando:
			if anima_player.animation != "vuela_agua":
				anima_player.play("vuela_agua")
				
	# Si disparo activo es igual a disparo2 se cambia a animación vuela_tierra
	elif disparo_activo == TipoDisparo.DISPARO2:
		if esta_caminando:
			if anima_player.animation != "vuela_tierra":
				anima_player.play("vuela_tierra")
				
	# Si disparo activo es igual a disparo3 se cambia a animación vuela_fuego
	elif disparo_activo == TipoDisparo.DISPARO3:
		if esta_caminando:
			if anima_player.animation != "vuela_fuego":
				anima_player.play("vuela_fuego")

# Función para niciar el parpadeo cuando el jugador recibe daño
func func_parpadeo_muerte():
	tiempo_parpadeo = 5.0 # Duración del efecto de parpadeo
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
			$agua.play()
			if anima_player.flip_h: #Si personaje esta mirando a la izquierda cuando dispara... 
				offset_x = -offset_x #Invierte el desplazamiento de disparo
				bullet.direction = Vector2.LEFT
				bullet.get_node("BALA1").flip_h = true
			else: #	Si player está mirando a la derecha cuando dispara...
				bullet.direction = Vector2.RIGHT #Proyectil se mueve a la derecha
			bullet.position = position + Vector2(offset_x, offset_y) #Coloca proyectil en la posición del personaje con el offset definido.
			
			
		TipoDisparo.DISPARO2: #Si tipo de disparo es el 2 (flor)
			bullet = Proyectil2.instantiate() #Instancia proyectil2
			$tierra.play()
			bullet.direction = Vector2.ZERO #disparo no se mueve
			bullet.position = Vector2(0, -10) #Coloca el proyectil en una zona fija
			add_child(bullet) #Añade proyectil como hijo del personaje por lo que se puede mover junto a él.
			return
			
		TipoDisparo.DISPARO3: #Si tipo de disparo es el 3 (fuego)
			bullet = Proyectil3.instantiate() #Instancia proyectil3
			$fuego.play()
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
	$librosonido.stream_paused = false
	match tipo:
		"disparo1":
			disparo_activo = TipoDisparo.DISPARO1
			cambiar_animacion(false)
			$librosonido.play()
		"disparo2":
			disparo_activo = TipoDisparo.DISPARO2
			cambiar_animacion(false)
			$librosonido.play()
		"disparo3":
			disparo_activo = TipoDisparo.DISPARO3
			cambiar_animacion(false)
			$librosonido.play()
		_:
			print("Power-up desconocido:", tipo)

# Función que se llama cuando el jugador es golpeado por un enemigo
func _on_hit_by_enemy():
	$muerte.play()
	vidas_nodo.perder_vida()  # Llama al método para restar vidas
	func_parpadeo_muerte() #Llama a la función parpadeo muerte
	
	
# Función que se llama cuando el jugador entra en contacto con un enemigo
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemigos"):  # Verifica si el cuerpo que tocó es un enemigo mediante su correspondiente grupo
		_on_hit_by_enemy()  # Resta vida al jugador


func _on_tiempo_libre_finalizado():
	libre_movimiento = false

# Deshabilitar los CollisionShape2D
func deshabilitar_colisiones():
	$CollisionShape2D.disabled = true  # Deshabilita el CollisionShape2D del Player
	$Area2D/CollisionShape2D.disabled = true  # Deshabilita el CollisionShape2D dentro del Area2D

# Habilitar los CollisionShape2D
func habilitar_colisiones():
	$CollisionShape2D.disabled = false  # Habilita el CollisionShape2D del Player
	$Area2D/CollisionShape2D.disabled = false  # Habilita el CollisionShape2D dentro del Area2D


var esta_reapareciendo := false
var tiempo := 0.0  # variable para animar el movimiento leve seno/coseno

func _on_screen_exited():
	vidas_nodo.perder_vida()
	position = Vector2(960, 540)
	libre_movimiento = true
	temporizador_retorno.start()
	deshabilitar_colisiones()
	esta_reapareciendo = true  # Activamos movimiento suave
	$vuela.play()
	esta_reapareciendo = false  # Paramos el movimiento suave
	habilitar_colisiones()


func _process(delta):
	if esta_reapareciendo:
		anima_player.play("fuera_camara")
		tiempo += delta
		# Movimiento leve en forma de onda (oscilación)
		position.y += sin(tiempo * 2.0) * 0.5  # Vertical
		position.x += cos(tiempo * 1.5) * 0.5  # Horizontal
