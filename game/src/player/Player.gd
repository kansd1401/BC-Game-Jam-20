extends Node2D

signal play(animation, direction)

var movement = Vector2()
var gravity = 2

onready var input_buffer = {
	"input": "",
	"timer": $Input_Buffer
}

var current_state = {
	"mode": "IDLE",
	"facing": "RIGHT",
	"hitbox_step": 0
}

export var speed = 0.2
export var max_speed = 5
export var max_fall = 10

func _ready():
	input_buffer.timer.set_wait_time(0.2)

func init(x, y):
	pass

func _process(delta):
	# Check for input buffer and perform action if state is idle.
	print(current_state)
	if current_state.mode == "MOVE_LEFT":
		movement.x -= speed
		current_state.facing = "LEFT"
		emit_signal("play", "WALK", current_state.facing)
	if current_state.mode == "MOVE_RIGHT":
		movement.x += speed
		current_state.facing = "RIGHT"
		emit_signal("play", "WALK", current_state.facing)
	if input_buffer.input == "" && current_state.mode == "IDLE":
		print("STOP PUH-LEASE")
		movement = Vector2()
	movement.x = clamp(movement.x, -max_speed, max_speed)
	movement.y = clamp(gravity, -max_fall, max_fall)
	position += movement
	

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

func _on_Controller_jump():
	if current_state.mode != "IDLE":
		input_buffer.input = "JUMP"
		input_buffer.timer.start()

# Movement keys will not buffer, but can be used to reset
#	the buffer.
func _on_Controller_move_left():
	if current_state.mode != "IDLE":
		input_buffer.input = ""
		input_buffer.timer.start()
		return
	current_state.mode = "MOVE_LEFT"

func _on_Controller_move_right():
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
