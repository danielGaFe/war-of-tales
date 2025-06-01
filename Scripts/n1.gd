extends Node2D #Nodo2D

@onready var marcador = $Marcador # Nodo encargado de gestionar los puntos del jugador
@onready var vidas = $Player_Idle/Vidas# Nodo encargado de gestionar las vidas del jugador
@onready var audio_player = $AudioStreamPlayer2D#Audio de la musica principal

func _ready():
	marcador.connect("mil_puntos_alcanzados", Callable(vidas, "ganar_vida"))
	#Si el nodo de audio tiene una pista cargada
	if audio_player.stream:
		audio_player.stream.loop = true  # Activo loop
		audio_player.play()# Reproduce la música
		
	for enemigo in get_tree().get_nodes_in_group("Enemigos"):# Recorro todos los nodos del grupo "Enemigos"
		if enemigo.has_signal("enemigo_muerto"):# Si el enemigo tiene la señal "enemigo_muerto"
			enemigo.enemigo_muerto.connect(_on_enemigo_muerto)# Conecta la señal "enemigo_muerto" del enemigo a la función "_on_enemigo_muerto"
	
func _on_enemigo_muerto(puntos):#Función que se ejecuta cuando un enemigo muere y emite la señal
	marcador.sumar_puntos(puntos)#Suma los puntos recibidos al marcador
