extends Node

var player_scene = preload("res://scenes/Player.tscn")
var spawn_point := Vector2.ZERO
var current_player_node = null

func _ready():
	spawn_point = $Player.global_position
	register_player($Player)

func register_player(player):
	current_player_node = player
	current_player_node.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)

func create_player():
	var new_player = player_scene.instance()
	add_child_below_node(current_player_node, new_player)
	new_player.global_position = spawn_point
	register_player(new_player)

func on_player_died():
	current_player_node.queue_free()
	create_player()
