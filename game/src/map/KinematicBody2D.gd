extends KinematicBody2D

var vel = Vector2()

func _ready():
	pass

func _process(delta):
	vel.y += 10
	move_and_slide(vel)


