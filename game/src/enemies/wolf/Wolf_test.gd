extends Node2D

onready var wolf = $Wolf

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_right"):
		wolf.play("RUN")
	if event.is_action_pressed("ui_up"):
		wolf.play("ATTACK")
	if event.is_action_pressed("ui_down"):
		wolf.play("IDLE")
	if event.is_action_pressed("ui_left"):
		wolf.play("DEATH")
