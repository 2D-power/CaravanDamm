extends Node3D

var is_game_running = false
var player_data: Dictionary #TODO:: stats for game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_zone_conquered(zone: Zone, by_player: String) -> void:
	pass

func quit_to_menu() -> void:
	is_game_running = false
	get_tree().change_scene_to_file("res://Screens/MainMenu.tscn")
