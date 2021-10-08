extends Camera2D

export(Color, RGB) var background_color

var target_position = Vector2.ZERO

func _ready():
	VisualServer.set_default_clear_color(background_color)

func _process(delta):
	_acquire_target_position()
	global_position = lerp(target_position, global_position, pow(2, -25 * delta))

func _acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	
	if (players.size() > 0):
		var player = players[0]
		target_position = player.global_position
