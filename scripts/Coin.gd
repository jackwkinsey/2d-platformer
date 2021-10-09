extends Node2D

func _ready():
	$AnimatedSprite.play("spin")
	var err = $Area2D.connect("area_entered", self, "on_area_entered")
	
	if err:
		print("Error occurred: " + str(err))

func on_area_entered(_area2d):
	$AnimationPlayer.play("collected")
	call_deferred("_disable")

func _disable():
	$Area2D/CollisionShape2D.disabled = true
