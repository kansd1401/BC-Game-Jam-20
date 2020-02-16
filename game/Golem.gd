extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var GRAVITY = 10
var direction = 1
var flipped = false
var hp = 100
var engaged = false
var target = null
var inRange = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timers/Idle.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed * direction
	velocity.y += GRAVITY
	if target:
		if (position.x - target.position.x) > 0 && direction > 0:
			change_direction()
		elif (position.x - target.position.x) < 0 && direction < 0:
			change_direction()
	if velocity.x == 0:
		$GolemAnimation/Walk.hide()
		$GolemAnimation/IdleE.show()
		$GolemAnimation/Attack.hide()
		$GolemAnimation/AnimationPlayer.play("IdleE")
	else:
		$GolemAnimation/Walk.show()
		$GolemAnimation/IdleE.hide()
		$GolemAnimation/Attack.hide()
		$GolemAnimation/AnimationPlayer.play("Walk")
	if !$Rays/EdgeDetector.is_colliding():
		print("edge")
		change_direction()
	else:
		velocity.y = 0
	if $Rays/WallDetector.is_colliding():
		print("wall")
		change_direction()
	move_and_slide(velocity)

func change_direction():
	direction = direction*-1
	$Rays/EdgeDetector.position.x *= -1
	$Rays/WallDetector.position.x *= -1
	$Rays/WallDetector.cast_to.x *= -1
	if direction == 1:
		flipped = false
	else:
		flipped = true
	$GolemAnimation/Attack.flip_h = flipped
	$GolemAnimation/Death.flip_h = flipped
	$GolemAnimation/Idle.flip_h = flipped
	$GolemAnimation/IdleE.flip_h = flipped
	$GolemAnimation/Walk.flip_h = flipped

func _on_Walk_timeout():
	speed = 0
	$Timers/Idle.start()


func _on_Idle_timeout():
	speed = 30
	$Timers/Walk.start()


func _on_Area2D_body_entered(body):
	if body.has_method("damage_player"):
		engaged = true
		target = body
