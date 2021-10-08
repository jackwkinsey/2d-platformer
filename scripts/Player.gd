extends KinematicBody2D

var gravity := 300
var velocity := Vector2.ZERO
var max_horizontal_speed := 100
var jump_speed := -200

func _ready():
	pass

func _process(delta):
	var move_direction = Vector2.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = move_direction.x * max_horizontal_speed
	
	var jump_pressed = Input.is_action_just_pressed("jump")
	
	if (jump_pressed && is_on_floor()):
		velocity.y = jump_speed
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
