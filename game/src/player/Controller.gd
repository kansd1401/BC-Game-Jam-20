extends Node2D

signal move_left
signal move_right
signal jump
signal attack
signal idle

var last_input = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# ui_{left, right, up, down}
func _physics_process(_delta):
	get_input()

func get_input():
	#print(event)
	# Will have to tweak with priority here
	if Input.is_action_pressed("ui_left"):
		emit_signal("move_left")
		last_input = "move_left"
	elif Input.is_action_pressed("ui_right"):
		print("MOVE ME")
		emit_signal("move_right")
		last_input = "move_right"
	elif Input.is_action_pressed("ui_up"):
		emit_signal("jump")
		last_input = "jump"
#	elif event.is_action_pressed("ui_down"):
#		return
	elif Input.is_action_pressed("attack"):
		emit_signal("attack")
		last_input = "attack"
	else:
		if last_input != "":
			emit_signal("idle")
			last_input = ""
