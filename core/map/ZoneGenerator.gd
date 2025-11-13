# res://core/map/ZoneGenerator.gd
class_name ZoneGenerator

const Delaunay = preload("res://addons/gdDelaunay/Delaunay.gd")

static func generate_map(
	map_size: Vector2 = Vector2(800, 800),
	zone_count: int = 12,
	rng_seed: int = 0
) -> MapData:
	var rng = RandomNumberGenerator.new()
	rng.seed = rng_seed

	var bounds = Rect2(0, 0, map_size.x, map_size.y)

	# Генерируем точки Вороного (сайты)
	var sites: Array[Vector2]
	for i in zone_count:
		sites.append(Vector2(
			rng.randf() * map_size.x,
			rng.randf() * map_size.y
		))

	# Используем gdDelaunay
	var delaunay = Delaunay.new(bounds)
	for site in sites:
		delaunay.add_point(site)

	var triangles = delaunay.triangulate()
	var voronoi_sites = delaunay.make_voronoi(triangles)

	var map_data = MapData.new()
	var valid_site_count = 0
	for site in voronoi_sites:
		if delaunay.is_border_site(site):
			continue # пропускаем краевые ячейки

		var poly = site.polygon
		if poly.size() < 3:
			continue # пропускаем вырожденные

		var hue = rng.randf()
		var color = Color.from_hsv(hue, 0.5, 0.8)
		var zone = MapData.Zone3D.new(valid_site_count, poly, color)
		map_data.zones.append(zone)
		valid_site_count += 1

	OutpostPlacer.place_outposts(map_data, rng)
	return map_data
