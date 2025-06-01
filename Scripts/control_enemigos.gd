extends Node2D
#Precargas de escenas
var mosquito_escena := preload("res://escenas/mosquitoSH.tscn")#Escena del enemigo mosquito
var pajaro_escena := preload("res://escenas/pajaroSH.tscn")#Escena del enemigo pajaro
var power_vida_escena := preload("res://escenas/powerVida_sh2.tscn")#Escena de powervida
var libro_escena := preload("res://escenas/libroSH.tscn")#Escena del libro

# Patron mosquito
var posiciones_mosquito := [#Presento por pantalla 3 mosquitos
	Vector2(1900, 300),#Posiciono el mosquito1 horizontal/vertical
	Vector2(2000, 600),#Posiciono el mosquito2 horizontal/vertical
	Vector2(2100, 900),#Posiciono el mosquito3 horizontal/vertical
]
var offset_x_mosquito := 0#Desplazamiento horizontal
var repeticiones_mosquito := 0#repeticiones minimas
var max_repeticiones_mosquito := 20#repeticiones máximas

# Patron pajaro
var posiciones_pajaro := [
	Vector2(1900, 200),#Posiciono el pajaro1 horizontal/vertical
	Vector2(1900, 450),#Posiciono el pajaro2 horizontal/vertical
	Vector2(1900, 650),#Posiciono el pajaro3 horizontal/vertical
	Vector2(1900, 900)#Posiciono el pajaro4 horizontal/vertical
]
var offset_x_pajaro := 0#Desplazamiento horizontal
var repeticiones_pajaro := 0#repeticiones minimas
var max_repeticiones_pajaro := 10#repeticiones máximas

var posiciones_vida := [
	Vector2(1900, 200)  # Posición inicial
]
var offset_x_vida := 0#Desplazamiento horizontal
var repeticiones_vida := 0#repeticiones minimas
var max_repeticiones_vida := 10  #repeticiones máximas

var posiciones_libro := [
	Vector2(1900, 200)  # Posición inicial
]
var offset_x_libro := 0#Desplazamiento horizontal
var repeticiones_libro := 0#repeticiones minimas
var max_repeticiones_libro := 10  #repeticiones máximas

func _ready():
	# Timer para mosquito
	var timer_mosquito := Timer.new()#Creo instancia del nodo Timer
	timer_mosquito.wait_time = 2.0#Espero 2 segundos entre ciclo y ciclo
	timer_mosquito.one_shot = false#Indico que no es de un solo uso 
	timer_mosquito.autostart = true#Indico que el temporizador comience automáticamente
	add_child(timer_mosquito)#Añado el temporizador como hijo del nodo actual
	timer_mosquito.timeout.connect(_on_timer_timeout_mosquito)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo
	timer_mosquito.start()#Inicio el temporizador

	# Timer para peces
	var timer_pajaro := Timer.new()#Creo instancia del nodo Timer
	timer_pajaro.wait_time = 5.0#Espero 5 segundos entre ciclo y ciclo
	timer_pajaro.one_shot = false#Indico que no es de un solo uso 
	timer_pajaro.autostart = true#Indico que el temporizador comience automáticamente
	add_child(timer_pajaro)#Añado el temporizador como hijo del nodo actual
	timer_pajaro.timeout.connect(_on_timer_timeout_pajaro)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo
	timer_pajaro.start()#Inicio el temporizador
	
		# Timer para power-up vida
	var timer_vida := Timer.new()#Creo instancia del nodo Timer
	timer_vida.wait_time = 7.0  #Espero 7 segundos entre ciclo y ciclo
	timer_vida.one_shot = false#Indico que no es de un solo uso 
	timer_vida.autostart = true#Indico que el temporizador comience automáticamente
	add_child(timer_vida)#Añado el temporizador como hijo del nodo actual
	timer_vida.timeout.connect(_on_timer_timeout_vida)#Conecto la señal 'timeout' del temporizador a la función que se ejecutará cuando termine el tiempo
	timer_vida.start()#Inicio el temporizador
	
	# Timer para libro
	var timer_libro := Timer.new()#Creo instancia del nodo Timer
	timer_libro.wait_time = 2.0  #Espero 2 segundos entre ciclo y ciclo
	timer_libro.autostart = true#Indico que el temporizador comience automáticamente


func _on_timer_timeout_mosquito():# Función que se ejecuta cuando se cumple el tiempo del temporizador del mosquito
	genera_patron_mosquito()# Llamo a la función que genera el patrón de aparición de mosquito

func _on_timer_timeout_pajaro():# Función que se ejecuta cuando se cumple el tiempo del temporizador del pajaro
	genera_patron_pajaro()# Llamo a la función que genera el patrón de aparición de pajaro

func _on_timer_timeout_vida():# Función que se ejecuta cuando se cumple el tiempo del temporizador de powervida
	genera_power_vida()# Llamo a la función que genera el patrón de aparición de powervida

func _on_timer_timeout_libro():# Función que se ejecuta cuando se cumple el tiempo del temporizador del libro
	genera_power_libro()# Llamo a la función que genera el patrón de aparición de libro

func genera_patron_mosquito():#Función para generar un patrón de enemigos mosquito
	if repeticiones_mosquito >= max_repeticiones_mosquito:# Si ha alcanzado el número máximo de repeticiones, salgo de la función
		return
	for pos in posiciones_mosquito:# Recorro todas las posiciones predefinidas para generar mosquitos
		genera_enemigo(mosquito_escena, pos + Vector2(offset_x_mosquito, 0))# Genero un enemigo mosquito_escena en la posición actual desplazada en el eje X
	offset_x_mosquito += 100# Desplazo el offset horizontal para que en el próximo patrón de mosquits no aparezcan en el mismo sitio
	repeticiones_mosquito += 1#Sumo 1 al número de repeticiones realizadas


func genera_patron_pajaro():#Función para generar un patrón de enemigos pajaro
	if repeticiones_pajaro >= max_repeticiones_pajaro:# Si ha alcanzado el número máximo de repeticiones, salgo de la función
		return
	for pos in posiciones_pajaro:# Recorro todas las posiciones predefinidas para generar pajaros
		genera_enemigo(pajaro_escena, pos + Vector2(offset_x_pajaro, 0))# Genero un enemigo pajaro_escena en la posición actual desplazada en el eje X
	offset_x_pajaro += 500# Desplazo el offset horizontal para que en el próximo patrón de pajaros no aparezcan en el mismo sitio
	repeticiones_pajaro += 1#Sumo 1 al número de repeticiones realizadas

func genera_power_vida(): #Función para generar un patrón de powervida
	if max_repeticiones_vida != -1 and repeticiones_vida >= max_repeticiones_vida:#Si ha alcanzado el número máximo de repeticiones y no es infinito (-1), no se genera más
		return
	for pos in posiciones_vida:# Recorro todas las posiciones predefinidas para generar powervida
		var random_y = randi_range(0, 1920) #Posiciono verticalmente de forma aleatoria edntro del rango especificado
		var nueva_pos = Vector2(pos.x + offset_x_vida, random_y)# Genero un powervida en posición aleatoria verticalmente
		genera_enemigo(power_vida_escena, nueva_pos)#Genero powerup en la posición calculada

func genera_power_libro():#Función para generar un patrón de libros
	if max_repeticiones_libro != -1 and repeticiones_libro >= max_repeticiones_libro:#Si ha alcanzado el número máximo de repeticiones y no es infinito (-1), no se genera más
		return
	for pos in posiciones_libro:# Recorro todas las posiciones predefinidas para generar libro
		var random_y = randi_range(0, 1920)  #Posiciono verticalmente de forma aleatoria edntro del rango especificado
		var nueva_pos = Vector2(pos.x + offset_x_vida, random_y)# Genero un libro en posición aleatoria verticalmente
		genera_enemigo(libro_escena, nueva_pos)#Genero libro en la posición calculada

func genera_enemigo(escena: PackedScene, posicion: Vector2):# Función para generar un enemigo a partir de una escena en la posición indicada
	var instancia := escena.instantiate()# Creo una instancia de la escena pasada como parámetro
	instancia.global_position = posicion# Establezco la posición global de la instancia generada
	add_child(instancia)#Añado la instancia como hijo dl nodo actual para que aparezca en la escena
	if instancia.has_signal("enemigo_muerto"):# Si la instancia tiene una señal llamada "enemigo_muerto", la conecta a una función local...
		instancia.connect("enemigo_muerto", Callable(self, "_on_enemigo_muerto"))
		
func _on_enemigo_muerto(puntos):# Función que se ejecuta cuando un enemigo emite la señal "enemigo_muerto" para sumar los puntos
	var marcador = get_node("/root/NIVEL2/Marcador") # Obtengo el nodo marcador desde la escena principal
	marcador.sumar_puntos(puntos)#Llamo a la función sumar_puntos del nodo marcador para sumar la puntuación
