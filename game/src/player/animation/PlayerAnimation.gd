extends Node2D

# Is going to accept signals/direct calls to play animations.
# Will ensure only one animation is playing at any given time.

onready var player = $AnimationPlayer

onready var animation_lookup = {
	"IDLE": $Idle,
	"WALK": $Walk,
	"JUMP": $Jump,
	"ATTACK": $Attack,
	"DASH": $Dash,
	"DEATH": $Death,
	"LEAP": $Leap,
	"SPIN": $Spin,
	"TAUNT": $Taunt
}

var current_playing = "IDLE"
var flip_sprite = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play(animation_name, direction):
	face(animation_name, direction)
	animation_name = animation_name.to_upper()
	if animation_lookup.has(animation_name):
		_switch_to(animation_name)

func _switch_to(animation_name):
	if (animation_name != current_playing):
		animation_lookup[current_playing].hide()
		animation_lookup[animation_name].show()
		player.play(animation_name)
		current_playing = animation_name

func face(animation_name, direction):
	if direction == "LEFT":
		flip_sprite = true
	elif direction == "RIGHT":
		flip_sprite = false
	animation_lookup[animation_name].set_flip_h(flip_sprite)

func _on_Player_play(animation, direction):
	play(animation, direction)






















