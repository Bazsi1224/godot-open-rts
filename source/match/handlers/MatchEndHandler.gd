extends CanvasLayer

@onready var _match = find_parent("Match")
@onready var _victory_tile = find_child("Victory")
@onready var _defeat_tile = find_child("Defeat")
@onready var _finish_tile = find_child("Finish")


func _ready():
	hide()
	_victory_tile.hide()
	_defeat_tile.hide()
	_finish_tile.hide()


# TODO: get rid of polling - act on unit_died signal instead
func _process(_delta):
	if visible:
		return
	var players = Utils.Set.new()
	for unit in get_tree().get_nodes_in_group("units"):
		players.add(unit.player)
	if _match.controlled_player != null and not players.has(_match.controlled_player):
		_defeat_tile.show()
		_show()
	elif (
		_match.controlled_player != null
		and players.has(_match.controlled_player)
		and players.size() == 1
	):
		_victory_tile.show()
		_show()
	elif players.size() == 1:
		_finish_tile.show()
		_show()


func _show():
	show()
	get_tree().paused = true


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://source/main-menu/Main.tscn")