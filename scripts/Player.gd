extends KinematicBody2D

var gravity := 1000
var velocity := Vector2.ZERO
var max_horizontal_speed := 140
var horizontal_acceleration = 2000
var jump_speed := -360
var jump_termination_multiplier := 4
var air_time := 0.0

func _ready():
	pass

func _process(delta):
	var move_direction = Vector2.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x += move_direction.x * horizontal_acceleration * delta
	if (move_direction.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	var jump_pressed = Input.is_action_just_pressed("jump")
	
	if (_on_floor(delta) && jump_pressed):
		velocity.y = jump_speed
		
	if (is_on_floor()):
		air_time = 0
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jump_termination_multiplier * delta
	else:
		velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_floor(delta):
	air_time += delta
	return is_on_floor() ||air_time < 0.15
