extends PathFollow2D #Clase de tipo PathFollow2D

@export var velocidad: float = 25# Velocidad a la que se mueve el nodo a lo largo del camino
@export var velocidadLluvia: float = 200.0 # Velocidad adicional, para simular el movimiento de la lluvia
var longitudTotal := 0.0 #Almacena la longitud total del camino a recorrer

func _ready():
	longitudTotal = get_parent().curve.get_baked_length()# Al iniciarse, se obtiene y se guarda la longitud del camino desde el nodo padre Path2D

func _process(delta):
	var distancia = velocidad * delta # Calcula la distancia a recorrer en cada frame según la velocidad y el tiempo transcurrido
	progress_ratio += distancia / longitudTotal # Aumenta su progreso durante el transcurso del camino, usando una proporción (de 0 a 1) basada en la longitud total
	var longitudCamino = get_parent().curve.get_baked_length() # Vuelve a obtener la longitud del camino
