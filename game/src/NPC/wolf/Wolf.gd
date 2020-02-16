extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var GRAVITY = 10
var direction = 1
var flipped = false
var hp = 100
var engaged = false

func _ready():
	$Timers/Idle.start()

func _process(delta):
	velocity.x = speed * direction
	velocity.y += GRAVITY
	if velocity.x == 0:
		$WolfAnimation/Run.hide()
		$WolfAnimation/Idle.show()
		$WolfAnimation/Attack.hide()
		$WolfAnimation/AnimationPlayer.play("IDLE")
	else:
		$WolfAnimation/Run.show()
		$WolfAnimation/Idle.hide()
		$WolfAnimation/Attack.hide()
		$WolfAnimation/AnimationPlayer.play("RUN")
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
	$WolfAnimation/Attack.flip_h = flipped
	$WolfAnimation/Death.flip_h = flipped
	$WolfAnimation/Idle.flip_h = flipped
	$WolfAnimation/Run.flip_h = flipped

func _on_Walk_timeout():
	speed = 0
	$Timers/Idle.start()


func _on_Idle_timeout():
	speed = 30
	$Timers/Walk.start()
