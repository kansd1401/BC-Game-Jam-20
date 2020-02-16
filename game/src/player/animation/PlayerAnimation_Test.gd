extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animation = $PlayerAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("NUM_1"):
		animation.play("ATTACK1", "RIGHT")
	if event.is_action_pressed("NUM_2"):
		animation.play("DASH", "RIGHT")
	if event.is_action_pressed("NUM_3"):
		animation.play("DEATH", "RIGHT")
	if event.is_action_pressed("NUM_4"):
		animation.play("IDLE", "RIGHT")
	if event.is_action_pressed("NUM_5"):
		animation.play("JUMP", "RIGHT")
	if event.is_action_pressed("NUM_6"):
		animation.play("LEAP", "RIGHT")
	if event.is_action_pressed("NUM_7"):
		animation.play("SPIN", "RIGHT")
	if event.is_action_pressed("NUM_8"):
		animation.play("TAUNT", "RIGHT")
	if event.is_action_pressed("NUM_9"):
		animation.play("WALK", "RIGHT")
