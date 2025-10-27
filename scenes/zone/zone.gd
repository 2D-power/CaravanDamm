class_name Zone
extends Node3D

enum ZoneType { PLAYER, GREEN, YELLOW, ORANGE, RED }

@export var zone_type: ZoneType = ZoneType.GREEN
@export var points: PackedVector2Array = []

@export var player: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var green: Color = Color(0.0, 0.701, 0.0, 1.0)
@export var yellow: Color = Color(0.796, 0.602, 0.065, 1.0)
@export var orange: Color = Color(0.929, 0.443, 0.059, 1.0)
@export var red: Color = Color(0.87, 0.0, 0.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if points.size() >= 3:
		_build_mesh()
		
func _build_mesh() -> void:
	var vertices := []
	var indices := []
	
	for i in range(points.size()):
		vertices.append(Vector3(points[i].x, 0.01, points[i].y))
	
	var tri = Geometry2D.triangulate_polygon(points)
	if tri.is_empty():
		push_error("Ошибка триангляции многоугольника зоны")
		return 
		
	indices = tri
	
	var mesh = ArrayMesh.new()
	var surf_tool = SurfaceTool.new()
	surf_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for idx in indices:
		surf_tool.add_vertex(vertices[idx])
		
	match zone_type:
		ZoneType.PLAYER: surf_tool.set_color(player)
		ZoneType.GREEN: surf_tool.set_color(green)
		ZoneType.YELLOW: surf_tool.set_color(yellow)
		ZoneType.ORANGE: surf_tool.set_color(orange)
		ZoneType.RED: surf_tool.set_color(red)
		
	surf_tool.generate_normals()
	surf_tool.generate_tangents()
	
	var mat = _get_material_for_zone_type()
	
	
	
	#if mat:
		#surf_tool.set_material(mat)
	surf_tool.commit(mesh)
		
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "ZoneMesh"
	mesh_instance.set_surface_override_material(0, mat)
	add_child(mesh_instance)

func _get_material_for_zone_type() -> Material:
	var material: Material = StandardMaterial3D.new()
	match zone_type:
		ZoneType.PLAYER: material.albedo_color = player
		ZoneType.GREEN: material.albedo_color = green
		ZoneType.YELLOW: material.albedo_color = yellow
		ZoneType.ORANGE: material.albedo_color = orange
		ZoneType.RED: material.albedo_color = red
	material.vertex_color_use_as_albedo = true
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.two_side_enabled = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	return material

func get_center_2d() -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	var sum = Vector2.ZERO
	for p in points:
		sum += p
	return sum / points.size()
	
func get_center_3d() -> Vector3:
	var c = get_center_2d()
	return Vector3(c.x, 0, c.y)
