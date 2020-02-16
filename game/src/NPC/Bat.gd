extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var GRAVITY = 10
var direction = Vector2(1, 1)
var bat_location = Vector2()
var flipped = false
var hp = 100
var engaged = false
var target = null
var inRange = false
var attacking = false
var moving = false

func _ready():
	$Timers/Idle.start()

func _process(delta):
	velocity.x = speed * direction.x 
	velocity.y = speed * direction.y
	
#	if $Rays/ForwardCollision.get_collider() != null:
#		print(($Rays/ForwardCollision.get_collider()))
#	if $Rays/HeadCollision.get_collider() != null:
#		print(($Rays/HeadCollision.get_collider()))
#	if $Rays/FeetCollision.get_collider() != null:
#		print(($Rays/FeetCollision.get_collider()))
#

	
	bat_location = get_position()
	if bat_location.y < 350:
		direction.y = 1
	
	if target:
		if (bat_location.x - target.position.x) > 0 && direction.x > 0:
			change_direction("forward")
		elif (bat_location.x - target.position.x) < 0 && direction.x < 0:
			change_direction("forward")
		elif (bat_location.y - target.position.y) < -5 && direction.y < 0:
			change_direction("head")
#
#	if $Rays/ForwardCollision.get_collider():
#		print($Rays/ForwardCollision.get_collider())
#	if $Rays/HeadCollision.get_collider():
#		print($Rays/HeadCollision.get_collider())
#	if $Rays/FeetCollision.get_collider():
#		print($Rays/FeetCollision.get_collider())
#
	if inRange:
		$BatAnimation/Flight.hide()
		$BatAnimation/Attack.show()
		$BatAnimation/AnimationPlayer.play("Attack")		
	else:
		$BatAnimation/Flight.show()
		$BatAnimation/Attack.hide()
		$BatAnimation/AnimationPlayer.play("Flight")
		
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
	print("WE CHANGING DIRECTIONS")
	if direction_change == "forward" && direction.x == 1:
		direction.x = -1
#		velocity.x = speed * direction.x
#		move_and_slide(velocity)
		$Rays/ForwardCollision.position.x *= direction.x
		$Rays/ForwardCollision.cast_to.x *= direction.x
		$Rays/HeadCollision.position.x *= direction.x
		$Rays/FeetCollision.position.x *= direction.x
	elif direction_change == "forward" && direction.x == -1:
#		velocity.x = speed * direction.x
#		move_and_slide(velocity)
		$Rays/ForwardCollision.position.x *= direction.x
		$Rays/ForwardCollision.cast_to.x *= direction.x
		$Rays/HeadCollision.position.x *= direction.x
		$Rays/FeetCollision.position.x *= direction.x
		direction.x = 1
	elif direction_change == "feet":
		direction.y = -1
	else:
		direction.y = 1
	
		
	if direction.x == 1:
		flipped = false
	else:
		flipped = true
	$BatAnimation/Attack.flip_h = flipped
	$BatAnimation/Death.flip_h = flipped
	$BatAnimation/Flight.flip_h = flipped
	
	print("why changing X on feet collision", direction.x)
	
func _on_Patrol_timeout():
	speed = 0
	$Timers/Idle.set_wait_time(rand_range(0, 1.5))
	$Timers/Idle.start()

func _on_Idle_timeout():
	speed = 50
	
#	if !engaged:
#		randomize()
#		if randi()%2 == 1:
#			direction.x = 1
#			print("changing direction to the right")
#			if $Rays/ForwardCollision.position.x < 0:
#				$Rays/ForwardCollision.position.x *= -1
#				$Rays/ForwardCollision.cast_to.x *= -1
#				$Rays/HeadCollision.position.x *= -1
#				$Rays/FeetCollision.position.x *= -1
#		else:
#			direction.x = -1
#			print("changing direction to the left") 
#			print(direction.x, "DEBUG THIS")
#			if $Rays/ForwardCollision.position.x > 0:
#				$Rays/ForwardCollision.position.x *= direction.x
#				$Rays/ForwardCollision.cast_to.x *= direction.x
#				$Rays/HeadCollision.position.x *= direction.x
#				$Rays/FeetCollision.position.x *= direction.x
#
#		if randi()%2 == 1:
#			direction.y = 1
#			print("changing direction to the down")
#		else:
#			direction.y = -1
#			print("changing direction to the up")

	$Timers/Patrol.set_wait_time(rand_range(1, 4))
	$Timers/Patrol.start()


func _on_Targetting_body_entered(body):
	if body.has_method("damage_player"):
		engaged = true
		target = body
		print("target detected")

func _on_Targetting_body_exited(body):
	if body == target:
		target = null
	print("target left")
	

func _on_Range_body_entered(body):
	if body == target:
		speed = 0
		inRange = true

func _on_Range_body_exited(body):
	if body == target:
		speed = 30
		inRange = false

func _attack_finished():
	attacking = false
	moving = false
	print("damage time")


func _on_Attack_timeout():
	if inRange:
		target.damage_player()

func _on_Death_timeout():
	queue_free()
