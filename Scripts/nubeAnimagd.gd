extends Sprite2D
@onready var anima_nube = $AnimationPlayer #referencia al animationplayer

func _ready():
	anima_nube.play("nube") #comienza la animación
