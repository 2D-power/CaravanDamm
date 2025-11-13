# res://scenes/ZoneVisual.gd
extends Node3D

@onready var mesh_instance = $MeshInstance3D

func setup_from_polygon_and_color(poly: PackedVector2Array, color: Color):
	# Триангулируем полигон
	var triangles = Geometry2D.triangulate_polygon(poly)
	if triangles.is_empty():
		printerr("Could not triangulate polygon for zone")
		return

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	# Вершины
	var vertices = PackedVector3Array()
	for pt in poly:
		vertices.append(Vector3(pt.x, 0.0, pt.y))

	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Индексы (из триангуляции)
	var indices = PackedInt32Array()
	for tri_idx_array in triangles:
		for idx in tri_idx_array:
			indices.append(idx)

	arrays[Mesh.ARRAY_INDEX] = indices

	# Создаём меш
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	# Применяем меш и материал
	mesh_instance.mesh = mesh
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED # чтобы было видно с обеих сторон
	mesh_instance.set_surface_override_material(0, mat)
