extends Node2D

#Precargas de escenas
var estrella_escena := preload("res://escenas/EstrellaSH.tscn") #	Escena del enemigo estrella de mar
var pez_escena := preload("res://escenas/pezSH.tscn")#Escena del enemigo pez
var power_vida_escena := preload("res://escenas/powerVida_sh.tscn")#	Escena del powerup energía
var libro_escena := preload("res://escenas/libroSH.tscn")#Escena del libro

# Patron estrella
var posiciones_estrella := [ #Presento por pantalla 3 estrellas
	Vector2(1900, 300),#Posiciono la estrella1 horizontal/vertical
	Vector2(2000, 600),#Posiciono la estrella2 horizontal/vertical
	Vector2(2100, 900)#Posiciono la estrella3 horizontal/vertical
]

var offset_x_estrella := 0 #Desplazamiento horizontal
var repeticiones_estrella := 0 #repeticiones minimas
var max_repeticiones_estrella := 10 #repeticiones máximas

# Patron pez
var posiciones_pez := [#Presento por pantalla 4 peces
	Vector2(1900, 200),#Posiciono la pez1 horizontal/vertical
	Vector2(1900, 450),#Posiciono la pez2 horizontal/vertical
	Vector2(1900, 650),#Posiciono la pez3 horizontal/vertical
	Vector2(1900, 900)#Posiciono la pez4 horizontal/vertical
]
var offset_x_pez := 0#Desplazamiento horizontal
var repeticiones_pez := 0#repeticiones minimas
var max_repeticiones_pez := 10#repeticiones máximas

var posiciones_vida := [
	Vector2(1900, 200)  #Posiciono la botella horizontal/vertical
]
var offset_x_vida := 0#Desplazamiento horizontal
var repeticiones_vida := 0#repeticiones minimas
var max_repeticiones_vida := 10  #repeticiones máximas

var posiciones_libro := [
	Vector2(1900, 200)  #Posiciono el libro horizontal/vertical
]
var offset_x_libro := 0#Desplazamiento horizontal
var repeticiones_libro := 0#repeticiones minimas
var max_repeticiones_libro := 10  #repeticiones máximas

func _ready():
	# Timer para estrellas
	var timer_estrella := Timer.new()#Creo instancia del nodo Timer
	timer_estrella.wait_time = 3.0#Espero 3 segundos entre ciclo y ciclo
	timer_estrella.one_shot = false#Indico que no es de un solo uso 
	timer_estrella.autostart = true#Indico que el temporizador comience automáticamente
	add_child(timer_estrella)#Añado el temporizador como hijo del nodo actual
	timer_estrella.timeout.connect(_on_timer_timeout_estrella)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo
	timer_estrella.start()#Inicio el temporizador

	# Timer para peces
	var timer_pez := Timer.new()#Creo instancia del nodo Timer
	timer_pez.wait_time = 5.0#Espero 5 segundos entre ciclo y ciclo
	timer_pez.one_shot = false#Indico que no es de un solo uso 
	timer_pez.autostart = true#Indico que el temporizador comience automáticamente
	add_child(timer_pez)#Añado el temporizador como hijo del nodo actual
	timer_pez.timeout.connect(_on_timer_timeout_pez)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo
	timer_pez.start()#Inicio el temporizador
	
		# Timer para power-up vida
	var timer_vida := Timer.new()#Creo instancia del nodo Timer
	timer_vida.wait_time = 6.0 #Espero 6 segundos entre ciclo y ciclo
	timer_vida.one_shot = false#Indico que no es de un solo uso 
	timer_vida.autostart = true#Indico que el temporizador comience automáticamente
	add_child(timer_vida)#Añado el temporizador como hijo del nodo actual
	timer_vida.timeout.connect(_on_timer_timeout_vida)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo
	timer_vida.start()#Inicio el temporizador
	
	# Timer para libro
	var timer_libro := Timer.new()#Creo instancia del nodo Timer
	timer_libro.wait_time = 10.0 #Espero 20 segundos entre ciclo y ciclo
	timer_libro.autostart = true#Indico que el temporizador comience automáticamente


func _on_timer_timeout_estrella():# Función que se ejecuta cuando se cumple el tiempo del temporizador de la estrella
	genera_patron_estrella()# Llamo a la función que genera el patrón de aparición de estrellas

func _on_timer_timeout_pez():# Función que se ejecuta cuando se cumple el tiempo del temporizador de pez
	genera_patron_pez()# Llamo a la función que genera el patrón de aparición de pez

func _on_timer_timeout_vida():# Función que se ejecuta cuando se cumple el tiempo del temporizador de powervida
	genera_power_vida()# Llamo a la función que genera el patrón de aparición de powervida

func _on_timer_timeout_libro():# Función que se ejecuta cuando se cumple el tiempo del temporizador de libro
	genera_power_libro()# Llamo a la función que genera el patrón de aparición de libro

func genera_patron_estrella():#Función para generar un patrón de enemigos estrella
	if repeticiones_estrella >= max_repeticiones_estrella:# Si ha alcanzado el número máximo de repeticiones, salgo de la función
		return
	for pos in posiciones_estrella: # Recorro todas las posiciones predefinidas para generar estrellas
		genera_enemigo(estrella_escena, pos + Vector2(offset_x_estrella, 0))# Genero un enemigo estrella_escena en la posición actual desplazada en el eje X
	offset_x_estrella += 300# Desplazo el offset horizontal para que en el próximo patrón de estrellas no aparezcan en el mismo sitio
	repeticiones_estrella += 1#Sumo 1 al número de repeticiones realizadas

func genera_patron_pez():#Función para generar un patrón de enemigos pez
	if repeticiones_pez >= max_repeticiones_pez:# Si ha alcanzado el número máximo de repeticiones, salgo de la función
		return
	for pos in posiciones_pez:# Recorro todas las posiciones predefinidas para generar peces
		genera_enemigo(pez_escena, pos + Vector2(offset_x_pez, 0))# Genero un enemigo pez_escena en la posición actual desplazada en el eje X
	offset_x_pez += 500# Desplazo el offset horizontal para que en el próximo patrón de estrellas no aparezcan en el mismo sitio
	repeticiones_pez += 1#Sumo 1 al número de repeticiones realizadas
	
func genera_power_vida():#Función para generar un patrón de powervida
	if max_repeticiones_vida != -1 and repeticiones_vida >= max_repeticiones_vida:#Si ha alcanzado el número máximo de repeticiones y no es infinito (-1), no se genera más
		return
	for pos in posiciones_vida:# Recorro todas las posiciones predefinidas para generar powervida
		var random_y = randi_range(0, 1920)  #Posiciono verticalmente de forma aleatoria edntro del rango especificado
		var nueva_pos = Vector2(pos.x + offset_x_vida, random_y)# Genero un powervida en posición aleatoria verticalmente
		genera_enemigo(power_vida_escena, nueva_pos)#Genero powerup en la posición calculada

func genera_power_libro():#Función para generar un patrón de libro
	if max_repeticiones_libro != -1 and repeticiones_libro >= max_repeticiones_libro:#Si ha alcanzado el número máximo de repeticiones y no es infinito (-1), no se genera más
		return
	for pos in posiciones_libro:# Recorro todas las posiciones predefinidas para generar libro
		var random_y = randi_range(0, 1920)  #Posiciono verticalmente de forma aleatoria dentro del rango especificado
		var nueva_pos = Vector2(pos.x + offset_x_vida, random_y)# Genero un libro en posición aleatoria verticalmente
		genera_enemigo(libro_escena, nueva_pos)#Genero libro en la posición calculada


func genera_enemigo(escena: PackedScene, posicion: Vector2):# Función para generar un enemigo a partir de una escena en la posición indicada
	var instancia := escena.instantiate()# Creo una instancia de la escena pasada como parámetro
	instancia.global_position = posicion # Establezco la posición global de la instancia generada
	add_child(instancia)#Añado la instancia como hijo dl nodo actual para que aparezca en la escena
	if instancia.has_signal("enemigo_muerto"):# Si la instancia tiene una señal llamada "enemigo_muerto", la conecta a una función local...
		instancia.connect("enemigo_muerto", Callable(self, "_on_enemigo_muerto"))

	
func _on_enemigo_muerto(puntos):# Función que se ejecuta cuando un enemigo emite la señal "enemigo_muerto" para sumar los puntos
	var marcador = get_node("/root/NIVEL4/Marcador")# Obtengo el nodo marcador desde la escena principal
	marcador.sumar_puntos(puntos)#Llamo a la función sumar_puntos del nodo marcador para sumar la puntuación
