extends KinematicBody2D

signal play(animation, direction)
signal land_jump
signal start_fall

var movement = Vector2()
var gravity = 3
var lock_horizontal = false
var is_dead = false

onready var input_buffer = {
	"input": "",
	"timer": $Input_Buffer
}

var current_state = {
	"mode": "IDLE",
	"facing": "RIGHT",
	"hitbox_step": 0
}

var current_attack = 1

export var hp = 200
var hp_max = hp
export var speed = 4
export var jump_strength = -215
export var max_speed = 100
export var max_fall = 800
export var attack_damage_1 = 40
export var attack_damage_2 = 60
export var attack_damage_3 = 80

func _ready():
	_on_PlayerAnimation_please_idle()
	input_buffer.timer.set_wait_time(0.2)

func init(x, y):
	pass

func _process(delta):
	if !is_dead:
		# Check for input buffer and perform action if state is idle.
		if current_state.mode == "MOVE_LEFT":
			movement.x -= speed
			current_state.facing = "LEFT"
			emit_signal("play", "WALK", current_state.facing)
		if current_state.mode == "MOVE_RIGHT":
			movement.x += speed
			current_state.facing = "RIGHT"
			emit_signal("play", "WALK", current_state.facing)
		if current_state.mode == "JUMP":
			pass
		if current_state.mode == "ATTACK":
			movement = Vector2()
			emit_signal("play", "ATTACK1", current_state.facing)
		if input_buffer.input == "" && current_state.mode == "IDLE":
			emit_signal("play", "IDLE", current_state.facing)
			movement = Vector2()
		movement.x = clamp(movement.x, -max_speed, max_speed)
		movement.y += clamp(gravity, -max_fall, max_fall)
		move_and_slide(movement)
		
		if $CheckGround.is_enabled():
			if $CheckGround.is_colliding():
				lock_horizontal = true
				reset_horizontal_movement()
				$PlayerAnimation._fall_resume()
				$CheckGround.set_enabled(false)
				$CheckLeftGround.set_enabled(true)
		
		if $CheckLeftGround.is_enabled():
			$CheckLeftGround.force_raycast_update()
			if !$CheckLeftGround.is_colliding():
				current_state.mode = "JUMP"
				if movement.y >= 0:
					movement.y = gravity
				print("Start fall puh-lease")
				emit_signal("start_fall", current_state.facing)
				$CheckLeftGround.set_enabled(false)
	else:
		pass

func reset_horizontal_movement():
	movement.x = 0

# Collision will have to be managed by player state, and at times will change a little wildly.
func update_collision():
	pass

# All inputs will set a buffer for that action that lasts x milliseconds.
# This buffer only contains one action and will be refreshed on key mashing,
# 	or changed and refreshed on another key being pressed.

func _on_Controller_attack():
	# If input is blocked, buffer it.
	if current_state.mode != "IDLE":
		input_buffer.input = "ATTACK"
		input_buffer.timer.start()
	else:
		current_state.mode = "ATTACK"

func _on_Controller_jump():
	if current_state.mode != "IDLE" && current_state.mode != "MOVE_LEFT" && current_state.mode != "MOVE_RIGHT":
		input_buffer.input = "JUMP"
		input_buffer.timer.start()
	else:
		current_state.mode = "JUMP"
		emit_signal("play", "JUMP", current_state.facing)

func _on_PlayerAnimation_jump_startup_ended():
	print("And jump")
	movement.y += jump_strength

# Movement keys will not buffer, but can be used to reset
#	the buffer.
func _on_Controller_move_left():
	if current_state.mode == "JUMP" && !lock_horizontal:
		movement += Vector2(-speed / 2, 0)
		move_and_slide(movement)
	if current_state.mode != "IDLE":
		input_buffer.input = ""
		input_buffer.timer.start()
		return
	current_state.mode = "MOVE_LEFT"

func _on_Controller_move_right():
	if current_state.mode == "JUMP" && !lock_horizontal:
		movement += Vector2(speed / 2, 0)
		move_and_slide(movement)
	if current_state.mode != "IDLE":
		input_buffer.input = ""
		input_buffer.timer.start()
		return
	current_state.mode = "MOVE_RIGHT"

func _on_Input_Buffer_timeout():
	input_buffer.input = ""

func _on_Controller_idle():
	if current_state.mode == "MOVE_LEFT" || current_state.mode == "MOVE_RIGHT":
		current_state.mode = "IDLE"

func _on_PlayerAnimation_please_idle():
	lock_horizontal = false
	if input_buffer.input == "":
		current_state.mode = "IDLE"
	elif input_buffer.input == "ATTACK":
		current_attack += 1
		if current_attack > 3:
			current_attack = 1
		current_state.mode = "ATTACK" + str(current_attack)
		emit_signal("play", "ATTACK" + str(current_attack), current_state.facing)
		return
	
	current_attack = 1

func _on_PlayerAnimation_revive():
	hp = hp_max
	_on_PlayerAnimation_please_idle()
	is_dead = false
	$CollisionShape2D.set_disabled(false)

func damage_player(dam):
	hp -= dam
	print(dam)
	if hp <= 0:
		emit_signal("play", "DEATH", current_state.facing)
		is_dead = true
		$CollisionShape2D.set_disabled(true)

func _on_PlayerAnimation_fall_paused():
	$CheckGround.set_enabled(true)


func _on_PlayerAnimation_attack_impact_1():
	var hitbox = $HitBoxes/Attack1
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("damage_npc"):
			body.damage_npc(attack_damage_1)


func _on_PlayerAnimation_attack_impact_2():
	var hitbox = $HitBoxes/Attack2
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("damage_npc"):
			body.damage_npc(attack_damage_2)


func _on_PlayerAnimation_attack_impact_3():
	var hitbox = $HitBoxes/Attack3
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("damage_npc"):
			body.damage_npc(attack_damage_3)
