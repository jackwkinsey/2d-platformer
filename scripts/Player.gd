extends KinematicBody2D

signal died

var gravity := 1000
var velocity := Vector2.ZERO
var max_horizontal_speed := 140
var horizontal_acceleration = 2000
var jump_speed := -360
var jump_termination_multiplier := 4
var air_time := 0.0
var has_double_jump := false

func _ready():
	var err = $HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	
	if err:
		print("Error occurred: " + str(err))

func _process(delta):
	var move_vector = _get_move_vector()
	velocity.x += move_vector.x * horizontal_acceleration * delta
	if (move_vector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	var jump_pressed = Input.is_action_just_pressed("jump")
	
	if (_on_floor()):
		has_double_jump = true
	
	if (jump_pressed && (_on_floor() || has_double_jump)):
		velocity.y = jump_speed
		if (!_on_floor()):
			has_double_jump = false
		$CoyoteTimer.stop()
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jump_termination_multiplier * delta
	else:
		velocity.y += gravity * delta
	
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	if (was_on_floor && !is_on_floor() && !jump_pressed):
		$CoyoteTimer.start()
	
	_update_animation()

func _get_move_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return move_vector

func _on_floor():
	return is_on_floor() || !$CoyoteTimer.is_stopped()

func _update_animation():
	var move_vector = _get_move_vector()
	
	if (!_on_floor()):
		$AnimatedSprite.play("jump")
	elif (move_vector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

	if (move_vector.x !=0):
		$AnimatedSprite.flip_h = true if (move_vector.x > 0) else false

func on_hazard_area_entered(_area2d):
	emit_signal("died")
	print("DIE!")
