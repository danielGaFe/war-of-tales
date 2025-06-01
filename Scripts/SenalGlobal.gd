extends Node

signal powerup_recogido(tipo) #Crea la señal powerup_recogido
var puntos: int = 0# Puntos actuales del jugador
var vidas: int = 3# Vidas actuales del jugador
var puntos_para_ranking: int = 0# Puntos usados para guardar en el ranking

func emitir_powerup(tipo):
	emit_signal("powerup_recogido", tipo) #Emitre señal de tipo de powerup recogido

var ranking = [] # Lista que contendrá el ranking de jugadores
const FILE_PATH := "user://ranking.save" # Ruta del archivo de guardado (espacio de usuario)
const MAX_ENTRADAS := 5 # Máximo número de entradas en el ranking

# Guarda una nueva puntuación en el ranking
func guardar_puntuacion(nombre: String, puntos: int):
	cargar()# Carga los datos actuales del archivo
	ranking.append({"nombre": nombre, "puntos": puntos})# Añade nueva entrada
	ranking.sort_custom(func(a, b): return a["puntos"] > b["puntos"])# Ordena de mayor a menor por puntos
	if ranking.size() > MAX_ENTRADAS:
		ranking = ranking.slice(0, MAX_ENTRADAS) # Limita el ranking a los primeros 5
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE) # Abre archivo para escribir
	file.store_var(ranking) # Guarda la lista de ranking
	file.close() # Cierra el archivo

# Carga el ranking desde el archivo
func cargar():
	if FileAccess.file_exists(FILE_PATH):# Verifica si existe el archivo
		var file = FileAccess.open(FILE_PATH, FileAccess.READ)
		ranking = file.get_var() # Recupera la variable guardada
		file.close()
	else:
		ranking = []#Si no existe, crea una lista vacía

func obtener_ranking():
	cargar()#Asegura que siempre esté actualizado desde el archivo
	return ranking
