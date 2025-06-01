extends CharacterBody2D #Rellena el marcador de poción al ser recogido

@onready var anima_pw_vida = $AnimaPWvida #Referencia al nodo AnimaPWnvida
@onready var detector = $Area2D #Referencia al nodo Area2D
var velocidad := Vector2(-500, 0)#velocidad 

func _ready():
	anima_pw_vida.play("pwvida") 	# Reproduce la animación del PowerUpvida
	detector.body_entered.connect(_on_body_entered) # Conecta la señal para detectar colisiones con el jugador

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"): # Verifica si el sprite entra en el área del jugador
		var cansancio_node = get_tree().get_root().get_node("NIVEL4/Cansancio") # Busca el nodo de Cansancio en la escena principal
		if cansancio_node: #Si cansancio_node existe
			cansancio_node.reiniciar_cansancio() #Se reinicia el marcador
		else: #De lo contrario...
			print("Nodo 'Cansancio' no encontrado") #Muestra por coutput este mensaje.
		queue_free()  # Elimina el PowerUp después de recogerlo

func _process(delta):
	position += velocidad * delta# Actualiza la posición del nodo según la velocidad y el tiempo entre frames
