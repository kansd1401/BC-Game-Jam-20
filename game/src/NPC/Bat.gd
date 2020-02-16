extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var GRAVITY = 10
var direction = Vector2(1, 1)
var flipped = false
var hp = 100
var engaged = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timers/Idle.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed * direction.x 
	velocity.y = speed * direction.y
	

	
	$BatAnimation/Flight.show()
	$BatAnimation/Attack.hide()
	$BatAnimation/Death.hide()
	$BatAnimation/AnimationPlayer.play("Flight")
	
	if $Rays/FeetCollision.is_colliding():
		print("feet touched something")
		change_direction("feet")
#	
	if $Rays/ForwardCollision.is_colliding():
		print("wall")
		change_direction("forward")
	if $Rays/HeadCollision.is_colliding():
		print("watch your head")
		change_direction("head")
	move_and_slide(velocity)

func change_direction(direction_change):
	if direction_change == "forward":
		direction.x = direction.x * -1
		$Rays/ForwardCollision.position.x *= -1
		$Rays/ForwardCollision.cast_to.x *= -1
		$Rays/HeadCollision.position.x *= -1
		$Rays/FeetCollision.position.x *= -1
		velocity.x = speed * direction.x
		move_and_slide(velocity)
	else:
		direction.y = direction.y * -1
		print("change directions not forward")
		
	if direction.x == 1:
		flipped = false
	else:
		flipped = true
	$BatAnimation/Attack.flip_h = flipped
	$BatAnimation/Death.flip_h = flipped
	$BatAnimation/Flight.flip_h = flipped
	
func _on_Patrol_timeout():
	speed = 0
	$Timers/Idle.start()


func _on_Idle_timeout():
	speed = 30
	$Timers/Patrol.start()
