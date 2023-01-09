extends Node3D

const CommandCenter = preload("res://source/match/units/CommandCenter.tscn")

@export var settings: Resource = null

var _controlled_player_id = null
var _visible_player_ids = []

@onready var _camera = find_child("IsometricCamera3D")


func _ready():
	_controlled_player_id = settings.controlled_player
	_visible_player_ids = settings.controlled_player  # TODO: add dedicated field in settings
	_spawn_initial_player_units()
	_move_camera_to_controlled_player_spawn_point()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		MatchSignals.deselect_all.emit()


func _spawn_initial_player_units():
	var spawn_points = find_child("SpawnPoints").get_children()
	for player_id in range(settings.players.size()):
		var command_center = CommandCenter.instantiate()
		command_center.color = settings.players[player_id].color
		command_center.global_transform = spawn_points[player_id].global_transform
		command_center.add_to_group("units")
		add_child(command_center)


func _move_camera_to_controlled_player_spawn_point():
	var spawn_points = find_child("SpawnPoints").get_children()
	for player_id in range(settings.players.size()):
		if player_id == _controlled_player_id:
			_camera.set_position_safely(spawn_points[player_id].global_transform.origin)
			break
