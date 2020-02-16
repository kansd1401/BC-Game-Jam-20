extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var motion = Vector2()
var last_input = ""
var in_animation = false
# Called when the node enters the scene tree for the first time.
onready	var animation = $BatAnimation/AnimationPlayer

func _physics_process(delta):
	
	if in_animation == false:
		animation.play("flight")
	if Input.is_action_pressed("ui_left"):
		motion.x = -100
		last_input = "move_left"
		animation.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		motion.x = 100
		last_input = "move_right"
		animation.flip_h = false
	elif Input.is_action_pressed("ui_up"):
		motion.y = -100
		last_input = "move_up"
	elif Input.is_action_pressed("ui_down"):
		motion.y = 100
		last_input = "move_down"
	elif Input.is_action_pressed("attack"):
		animation.stop()
		animation.play("attack")
#		in_animation = true
#		while in_animation == true:
#			print(animation.get_animation())
#			if animation.get_animation() != "attack":
#
#				animation.play("flight")
#				in_animation = false
		motion.y = 0
		motion.x = 0
		last_input = "attack"

	else:
		if last_input != "":
#			animation.play("flight")
			last_input = ""
			
#	if animation.is_playing() == false:
#		in_animation = false
#		animation.play("flight")
	move_and_slide(motion)
