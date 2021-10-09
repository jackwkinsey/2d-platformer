extends Node2D

func _ready():
	$AnimatedSprite.play("spin")
	$Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(area2d):
	$AnimationPlayer.play("collected")
	call_deferred("_disable")

func _disable():
	$Area2D/CollisionShape2D.disabled = true
