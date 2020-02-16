extends Node2D

signal please_idle
signal jump_startup_ended
signal fall_paused
signal attack_impact_1
signal attack_impact_2
signal attack_impact_3
signal revive

onready var player = $AnimationPlayer
onready var effect_player = $EffectPlayer

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

onready var effect_lookup = {
	"JUMP": $JumpEffect
}

var animation_speed = {
	"IDLE": 1,
	"WALK": 1,
	"JUMP": 12,
	"ATTACK1": 1.4,
	"ATTACK2": 1,
	"ATTACK3": 1,
	"DASH": 1,
	"DEATH": 0.2,
	"LEAP": 1,
	"SPIN": 1,
	"TAUNT": 1
}

var current_playing = "IDLE"
var flip_sprite = false
var reviving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play("JUMP", "LEFT")
	play("JUMP", "RIGHT")

func play(animation_name, direction):
	face(animation_name, direction)
	animation_name = animation_name.to_upper()
	if animation_lookup.has(animation_name):
		_switch_to(animation_name)
		if animation_name == "JUMP":
			_jump_start_speedup()

func _switch_to(animation_name):
	if (animation_name != current_playing):
		if effect_lookup.has(current_playing):
			effect_lookup[current_playing].hide()
		animation_lookup[current_playing].hide()
		
		animation_lookup[animation_name].show()
		if effect_lookup.has(animation_name):
			effect_lookup[animation_name].show()
			effect_player.set_speed_scale(animation_speed[animation_name])
			effect_player.play(animation_name)
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
	if animation == "JUMP":
		_jump_start_speedup()
	play(animation, direction)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ATTACK1" || anim_name == "ATTACK2" || anim_name == "ATTACK3":
		_switch_to("IDLE")
		emit_signal("please_idle")
	
	if anim_name == "JUMP":
		_switch_to("IDLE")
		emit_signal("please_idle")
	
	if anim_name == "DEATH":
		if reviving:
			_switch_to("IDLE")
			emit_signal("revive")
			reviving = false
		player.play_backwards("DEATH")
		reviving = true

func _jump_startup_ended():
	emit_signal("jump_startup_ended")

func _fall_pause():
	$AnimationPlayer.stop(false)
	emit_signal("fall_paused")

func _fall_resume():
	$AnimationPlayer.play()

func _jump_offset(x, y):
	var x_offset = x
	var y_offset = y
	if flip_sprite:
		x_offset *= -1
	$Jump.offset = Vector2(x_offset, y_offset)

func _attack_impact_1():
	emit_signal("attack_impact_1")

func _attack_impact_2():
	emit_signal("attack_impact_2")

func _attack_impact_3():
	emit_signal("attack_impact_3")

func _on_Player_start_fall(direction):
	face("JUMP", direction)
	animation_lookup[current_playing].hide()
	current_playing = "JUMP"
	animation_lookup["JUMP"].show()
	player.play("JUMP")
	player.seek(13, true)
	_jump_offset(-49, 15)
	player.set_speed_scale(animation_speed["JUMP"])
	player.play()
	_fall_pause()

func _jump_start_speedup():
	player.set_speed_scale(animation_speed["JUMP"] * 2)

func _jump_stop_speedup():
	player.set_speed_scale(animation_speed["JUMP"])












