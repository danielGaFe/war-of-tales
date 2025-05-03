extends Node

signal powerup_recogido(tipo) #Crea la señal powerup_recogido

func emitir_powerup(tipo):
	emit_signal("powerup_recogido", tipo) #Emitre señal de tipo de powerup recogido
