extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animation = $BatAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	
	# Will have to tweak with priority here
	if event.is_action_pressed("ui_left"):
		animation.play("move_left")
		last_input = "move_left"
	elif event.is_action_pressed("ui_right"):
		animation.play("move_right")
		last_input = "move_right"
	elif event.is_action_pressed("ui_up"):
		animation.play("jump")
		last_input = "jump"
	elif event.is_action_pressed("ui_down"):
		animation.play("move_down")
		last_input = "move_down"
	elif event.is_action_pressed("attack"):
		animation.play("attack")
		last_input = "attack"
	else:
		if last_input != "":
			animation.play("idle")
			last_input = ""
