extends Node2D

onready var player = $AnimationPlayer

onready var animation = {
	"IDLE": $Idle,
	"RUN": $Run,
	"ATTACK": $Attack,
	"DEATH": $Death
}

var current_movement = "IDLE"

func _ready():
	pass
	
func play(movements):
	var movement = movements.to_upper()
	if animation.has(movement):
		_switch(movement)

func _switch(movement):
	animation[current_movement].hide()
	animation[movement].show()
	player.play(movement)
	current_movement = movement
