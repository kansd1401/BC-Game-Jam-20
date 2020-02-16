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
var idling = false
var attacking = false
var walking = false
onready var anim = $GolemAnimation/AnimationPlayer
onready var spriteW = $GolemAnimation/Walk
onready var spriteA = $GolemAnimation/Attack
onready var spriteD = $GolemAnimation/Death
onready var spriteI = $GolemAnimation/IdleE
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
#	print(attacking)
#	print(velocity.x)
#	print(idling)
#	print(attacking)
#	print(walking)
	if hp > 0:
		if inRange && velocity.x == 0 && !attacking:
			spriteW.hide()
			spriteI.hide()
			spriteA.show()
			anim.play("Attack")
			$Timers/Attack.start()
			attacking = true
			idling = false
			walking = false
		elif velocity.x == 0 && !inRange && !idling:
			spriteW.hide()
			spriteI.show()
			spriteA.hide()
			anim.play("IdleE")
			attacking = false
			idling = true
			walking = false
		elif velocity.x != 0 && !walking:
			spriteW.show()
			spriteI.hide()
			spriteA.hide()
			anim.play("Walk")
			attacking = false
			idling = false
			walking = true
	if !$Rays/EdgeDetector.is_colliding():
		print("edge")
		change_direction()
	else:
		velocity.y = 0
	if $Rays/WallDetector.is_colliding():
		if $Rays/WallDetector.get_collider().get("hp") == null:
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
	spriteA.flip_h = flipped
	spriteD.flip_h = flipped
	spriteI.flip_h = flipped
	spriteW.flip_h = flipped

func damage_npc(dam):
	hp = hp-dam
	if hp <= 0:
		spriteW.hide()
		spriteI.hide()
		spriteA.hide()
		spriteD.show()
		anim.play("Death")
		$Timers/Death.start()

func _on_Walk_timeout():
	if !engaged:
		speed = 0
		$Timers/Idle.start()


func _on_Idle_timeout():
	if !engaged:
		speed = 30
		$Timers/Walk.start()


func _on_Area2D_body_entered(body):
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
	walking = false
	idling = false
	print("damage time")


func _on_Attack_timeout():
	if inRange:
		target.damage_player()

func _on_Death_timeout():
	queue_free()
