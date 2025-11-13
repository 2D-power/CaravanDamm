# res://editor/MapVisualizer3D.gd
@tool
extends Node3D

@export var regenerate_on_ready: bool = true

# Исправленное объявление переменной
var _map_data: MapData = null

func _ready():
	if regenerate_on_ready and Engine.is_editor_hint():
		regenerate_map()

func regenerate_map():
	# Удаляем старые визуалы
	for child in get_children():
		if child.name.begins_with("Zone_") or child.name.begins_with("Outpost_"):
			child.queue_free()

	# --- ИСПРАВЛЕНО: Присваивание вынесено отдельно ---
	_map_data = ZoneGenerator.generate_map(
		Vector2(800, 800),
		 10,
		 hash("test")
	)
	# -------------------------------------------------

	# Визуализируем зоны
	for zone in _map_data.zones:
		var zone_visual = preload("res://scenes/ZoneVisual.tscn").instantiate()
		zone_visual.name = "Zone_" + str(zone.id)
		zone_visual.setup_from_polygon_and_color(zone.polygon, zone.color)
		add_child(zone_visual)

	# Визуализируем форпосты
	for i in len(_map_data.zones):
		for j in len(_map_data.zones[i].outposts):
			var pt = _map_data.zones[i].outposts[j]
			var outpost = preload("res://scenes/OutpostVisual.tscn").instantiate()
			outpost.name = "Outpost_%d_%d" % [i, j]
			outpost.position = Vector3(pt.x, 0.0, pt.y)
			add_child(outpost)
