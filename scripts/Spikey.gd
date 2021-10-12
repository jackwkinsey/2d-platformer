extends KinematicBody2D

enum Direction { RIGHT, LEFT }
export(Direction) var start_direction

var max_speed := 25
var velocity := Vector2.ZERO
var direction := Vector2.RIGHT
var gravity := 500

func _ready():
	var err = $GoalDetector.connect("area_entered", self, "on_goal_entered")
	if err:
		print("Error occurred: " + str(err))
	
	direction = Vector2.RIGHT if start_direction == Direction.RIGHT else Vector2.LEFT

func _process(delta):
	velocity.x = (direction * max_speed).x
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$AnimatedSprite.flip_h = true if direction.x > 0 else false

func on_goal_entered(_area2d):
	direction *= -1
