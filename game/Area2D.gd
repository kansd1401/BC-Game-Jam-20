extends Area2D

export var speed = 700
export var damage = 15
export var life = 10.0

var velocity = Vector2()
var acceleration = Vector2()

var direction
var p_owner
signal explode_projectile
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(_position, _direction):
	print("boom bitch")
	position = _position
	$Lifetime.wait_time = life
	velocity.x = _direction * speed

func _process(delta):
	position += velocity * delta

func explode():
	velocity = Vector2()
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play()

func _on_Projectile_body_entered(body):
	if !body.has_method("damage_npc"):
		explode()
		if body.has_method("damage_player"):
			body.damage_player(damage)

func _on_Explosion_animation_finished():
	queue_free()


func _on_Lifetime_timeout():
	explode()
