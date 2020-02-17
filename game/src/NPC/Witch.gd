extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var GRAVITY = 10
var direction = 1
var flipped = false
var hp = 500
var damage = 25
var engaged = false
var target = null
var inRange = false
var idling = false
var attacking = false
var walking = false
var dead = false
onready var anim = $WitchAnimation/AnimationPlayer
onready var spriteW = $WitchAnimation/Walk
onready var spriteA = $WitchAnimation/Attack
onready var spriteD = $WitchAnimation/Death
onready var spriteI = $WitchAnimation/IdleE
export var fireball = preload("res://src/NPC/Projectile.tscn")

# Called when the node enters the scene tree for the first time.

func _ready():
	randomize()
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
			$Timers/Attack.start()
			anim.play("ATTACK")
			attacking = true
			idling = false
			walking = false
		elif velocity.x == 0 && !inRange && !idling:
			spriteW.hide()
			spriteI.show()
			spriteA.hide()
			anim.play("IDLEE")
			attacking = false
			idling = true
			walking = false
		elif velocity.x != 0 && !walking:
			spriteW.show()
			spriteI.hide()
			spriteA.hide()
			anim.play("WALK")
			attacking = false
			idling = false
			walking = true
	if !$Rays/EdgeDetector.is_colliding():
		if !engaged:
			change_direction()
		elif engaged && !$Rays/PlatformDetector.is_colliding():
			speed = 0
	else:
		velocity.y = 0
	if $Rays/WallDetector.is_colliding():
		if $Rays/WallDetector.get_collider().get("hp") == null:
			change_direction()
	move_and_slide(velocity)

func change_direction():
	direction = direction*-1
	$Rays/EdgeDetector.position.x *= -1
	$Rays/PlatformDetector.position.x *= -1
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
	if hp <= 0 && !dead:
		dead = true
		spriteW.hide()
		spriteI.hide()
		spriteA.hide()
		spriteD.show()
		anim.play("DEATH")
		$Timers/Death.start()

func _on_Walk_timeout():
	if !engaged:
		speed = 0
		$Timers/Idle.wait_time = range(1,5)[randi()%range(1,5).size()]
		$Timers/Idle.start()


func _on_Idle_timeout():
	if !engaged:
		speed = 30
		$Timers/Walk.wait_time = range(5,10)[randi()%range(5,10).size()]
		$Timers/Walk.start()


func _on_Area2D_body_entered(body):
	if body.has_method("damage_player"):
		speed = 45
		engaged = true
		target = body
		print("target detected")


func _on_Targetting_body_exited(body):
	if body == target:
		target = null
		engaged = false
		speed = 30
	print("target left")


func _on_Range_body_entered(body):
	if body == target:
		speed = 0
		inRange = true

func _on_Range_body_exited(body):
	if body == target:
		speed = 45
		inRange = false

func _attack_finished():
	attacking = false
	walking = false
	idling = false


func _on_Attack_timeout():
	print("attcking")
	var proj = fireball.instance()
	get_parent().add_child(proj)
	proj.start(position, direction)
	attacking = false

func _on_Death_timeout():
	queue_free()
