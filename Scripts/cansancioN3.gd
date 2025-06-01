extends CanvasLayer # Nodo de interfaz de usuario (UI) que permanece fijo en pantalla.

var marcador = [10] # Lista que actúa como contador de "cansancio" o energía del personaje.

@onready var timer = $Timer # Referencia al nodo Timer hijo.
@onready var anim_pocion = $AnimaCansancio # Referencia al nodo AnimationPlayer que muestra la animación de la poción de cansancio
var vidas_nodo # Variable que almacena la referencia al nodo que gestiona las vidas del personaje.

func _ready():
	call_deferred("obtener_nodo_vidas") # Llama a la función obtener_nodo_vidas después de cargar la escena.
	timer.start(3) #Inicia el temporizador con un intervalo de 2 segundos.
	timer.timeout.connect(self.cuandoTerminaTiempo) # Conecta la señal timeout del Timer a la función cuandoTerminaTiempo()
	actualizar_frame() # Actualiza el frame de la animación según el valor del marcador.

func obtener_nodo_vidas():
	vidas_nodo = get_node("/root/NIVEL3/Player_Idle/Vidas") # Obtiene el nodo de vidas del jugador en la escena principal.

func cuandoTerminaTiempo():
	if marcador.size() > 0: #Si la lista marcador tiene un valor superior a 0...
		marcador[0] -= 1 #Resta 1 al valor del marcador (simula aumento de cansancio).
	if marcador[0] <= 0 and vidas_nodo: # Si el valor llega a 0 o menos y el nodo de vidas existe...
		vidas_nodo.perder_vida() # Llama al método perder_vida() del nodo vidas_nodo.
	actualizar_frame() # Actualiza el frame de la animación tras el cambio de marcador.
	timer.start(2) #Reinicia el temporizador para repetir el ciclo.

func actualizar_frame():
	var valor = marcador[0] #Obtiene el valor actual del marcador
	anim_pocion.animation = "cansancio" # Establece la animación activa en el AnimationPlayer.
	anim_pocion.frame = 10 - valor #Ajusta el frame en función del valor actual de marcador.

func reiniciar_cansancio(): # Función utilizada al recoger un ítem de recuperación.
	$pocion.play()#Reproduce sonido
	marcador[0] = 10 #Reinicia el marcador al valor original (10).
	actualizar_frame() # Actualiza la animación tras el reinicio del marcador.
