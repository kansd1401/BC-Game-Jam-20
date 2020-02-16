extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal attack_finished
var played = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	if $AnimationPlayer.is_playing():
#		if played:
#			print("emiting")
#			emit_signal("attack_finished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AnimationPlayer_animation_started(anim_name):
	print("animation startring"+anim_name)
	played = false#	$AnimationPlayer.clear_queue()


func _on_AnimationPlayer_animation_finished(anim_name):
	pass
	


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	print("emiting")
	emit_signal("attack_finished")
