extends Node2D #Nodo2D

@onready var marcador = $Marcador #Referencia al nodo marcador

func _ready():
	for enemigo in get_tree().get_nodes_in_group("Enemigos"):#Recorre los nodos del grupo Enemigos
		enemigo.enemigo_muerto.connect(_on_enemigo_muerto) #Conecta la señal de enemigo_muerto de cada enemigo a la función _on_enemigo_muerto de este nodo

func _on_enemigo_muerto(puntos):#Cuando un enemigo emit
	marcador.sumar_puntos(puntos)
