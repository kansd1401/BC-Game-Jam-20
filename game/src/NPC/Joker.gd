extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var GRAVITY = 10
var direction = 1
var flipped = false
var hp = 100
var engaged = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed * direction
	velocity.y += GRAVITY
	if velocity.x == 0:
		$JokerAnimation/Idle.show()
		$JokerAnimation/Attack.hide()
		$JokerAnimation/AnimationPlayer.play("Idle")
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
	$JokerAnimation/Attack.flip_h = flipped
	$JokerAnimation/Death.flip_h = flipped
	$JokerAnimation/Idle.flip_h = flipped

