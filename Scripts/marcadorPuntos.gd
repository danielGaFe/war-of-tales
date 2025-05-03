extends CanvasLayer #Nodo de interfaz de usuario (UI) que permanece fijo en pantalla.

@onready var label = $Label #Obtiene una referencia al nodo Label hijo.
var puntos = 0 #Variable para almacenar puntos

func sumar_puntos(cantidad): #Función para sumar puntos al marcador
	puntos += cantidad # Suma la cantidad recibida a la puntuación actual.
	label.text = "Score: \n" + str(puntos) # Actualiza el texto de Label mostrando la nueva puntuación.
