extends Node2D

onready var wolf = $Wolf

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_right"):
		wolf.play("RUN")
	if event.is_action_pressed("")
