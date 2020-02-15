extends Node2D

signal move_left
signal move_right
signal jump
signal attack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# ui_{left, right, up, down}

func _input(event):
	if event.is_action_pressed("ui_left"):
		emit_signal("move_left")
	if event.is_action_pressed("ui_right"):
		emit_signal("move_right")
	if event.is_action_pressed("ui_up"):
		emit_signal("jump")
	if event.is_action_pressed("ui_down"):
		return
	if event.is_action_pressed("attack"):
		emit_signal("attack")
