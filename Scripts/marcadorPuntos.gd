extends CanvasLayer

signal mil_puntos_alcanzados # Señal que emite cuando se acumulan 1000 puntos

@onready var label = $Puntos# Referencia al nodo Label que muestra los puntos por pantalla
var puntos_desde_ultimo_mil = 0# Lleva recuento de los puntos sumados desde que alcanzó los últimos 1000 puntos

func _ready():
	if label != null:
		label.text = "Score: \n" + str(SenalGlobal.puntos) # Muestra el valor actual de los puntos
	else:
		print("No se encontró el nodo Label aún.")

#Función para sumar puntos al marcador
func sumar_puntos(cantidad: int) -> void:
	SenalGlobal.puntos += cantidad #Suma puntos al contador global
	puntos_desde_ultimo_mil += cantidad #Suma al contador para saber cuando se llega a cada 1000 puntos
	_actualizar_label()#Actualiza el texto en pantalla
	while puntos_desde_ultimo_mil >= 1000: #Cuando puntos desde ultimo mil supere los 1000
		puntos_desde_ultimo_mil -= 1000 # Resta los 1000 puntos acumulados
		emit_signal("mil_puntos_alcanzados") # Lanza la señal de mil puntos alcanzados
		$vidanueva.play() #Reproduce sonido de vida nueva

# Función que actualiza el texto del marcador
func _actualizar_label():
	label.text = "Score: \n" + str(SenalGlobal.puntos)
