#Script utilizado para las bolas péndulo del nível1
extends CharacterBody2D

@onready var anima_rayo = $AnimaBola #Referencia a la animación
@onready var area = $Area2D#Referencia al area2d

func _ready():
	anima_rayo.play("bola")#Da comienzo la animación
	area.body_entered.connect(_on_body_entered) # Conecto la señal de body_entered de area con la función _on_body_entered

# Función automática para cuando un cuerpo entra en el área de colisión
func _on_body_entered(body):
	if body.is_in_group("Player"):#Si bola toca al grupo player
		body.func_parpadeo_muerte()# Llamo a la función para activar el efecto de parpadeo de player
		# Lógica para restar una vida
		var vidas_nodes = get_tree().get_nodes_in_group("Vidas")# Obtiene todos los nodos del grupo "Vidas"
		if vidas_nodes.size() > 0:# Si vidas_nodes es mayor a 0
			vidas_nodes[0].perder_vida()#Llamo a la función de perder vida
		area.set_deferred("monitoring", false)# Desactivo de forma temporal la detección de colisiones
		await get_tree().create_timer(2.0).timeout# Espera 2 segundos
		area.set_monitoring(true)#Activo de nuevo la detección de colisiones
