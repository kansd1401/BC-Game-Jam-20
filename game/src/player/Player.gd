extends Node2D


var x
var y

onready var input_buffer = {
	"input": "",
	"timer": $Input_Buffer
}

var current_state = "IDLE"

export var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	input_buffer.timer.set_wait_time(0.2)

func init(x, y):
	pass

func _process(delta):
	# Check for input buffer and perform action if state is idle.
	if input_buffer.input != "" && current_state == "IDLE":
		pass # Perform buffered action

# Collision will have to be managed by player state, and at times will change a little wildly.
func update_collision():
	pass

# All inputs will set a buffer for that action that lasts x milliseconds.
# This buffer only contains one action and will be refreshed on key mashing,
# 	or changed and refreshed on another key being pressed.

func _on_Controller_attack():
	# If input is blocked, buffer it.
	if current_state != "IDLE":
		input_buffer.input = "ATTACK"
		input_buffer.timer.start()

func _on_Controller_jump():
	pass # Replace with function body.


func _on_Controller_move_left():
	pass # Replace with function body.


func _on_Controller_move_right():
	pass # Replace with function body.


func _on_Input_Buffer_timeout():
	input_buffer.input = ""
