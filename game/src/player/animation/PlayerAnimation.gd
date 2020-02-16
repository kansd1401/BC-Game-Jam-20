extends Node2D

signal please_idle

onready var player = $AnimationPlayer

onready var animation_lookup = {
	"IDLE": $Idle,
	"WALK": $Walk,
	"JUMP": $Jump,
	"ATTACK1": $Attack1,
	"ATTACK2": $Attack2,
	"ATTACK3": $Attack3,
	"DASH": $Dash,
	"DEATH": $Death,
	"LEAP": $Leap,
	"SPIN": $Spin,
	"TAUNT": $Taunt
}

var animation_speed = {
	"IDLE": 1,
	"WALK": 1,
	"JUMP": 1,
	"ATTACK1": 1.4,
	"ATTACK2": 1,
	"ATTACK3": 1,
	"DASH": 1,
	"DEATH": 1,
	"LEAP": 1,
	"SPIN": 1,
	"TAUNT": 1
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
		# Set scale based on animation here
		player.set_speed_scale(animation_speed[animation_name])
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

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ATTACK1" || anim_name == "ATTACK2" || anim_name == "ATTACK3":
		_switch_to("IDLE")
		emit_signal("please_idle")
	
	if anim_name == "JUMP":
		_switch_to("IDLE")
		emit_signal("please_idle")























