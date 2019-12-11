extends Node2D

const projection_ratio = 0.5
var log_projection_ratio = log(projection_ratio)
const fog_ratio = 0.65
export var depth = 7
var velocity = Vector2()
var angular_velocity = 0
var collided = false
onready var polygon = get_node_or_null("Polygon2D")

func _ready():
	if polygon != null:
		var points = PoolVector2Array()
		points.resize(8 + 6 % randi())
		for i in range(points.size()):
			points[i] = Vector2(300 + 100 * randf(), 0).rotated(2 * PI * (i + randf()) / points.size())
		polygon.polygon = points

func _process(delta):
	step(delta)

func step(delta):
	var d_depth = delta * get_parent().velocity
	depth -= d_depth
	scale = Vector2(1, 1) * pow(projection_ratio, depth)
	position += (get_global_mouse_position() - global_position) * log_projection_ratio * d_depth
	position += velocity * pow(projection_ratio, depth)
	rotation += angular_velocity * delta
	var c = pow(fog_ratio, depth)
	modulate = Color(c, c * 0.5, c * 0.5, 1) if collided else Color(c, c, c, 1)
	
	if depth < 0 and not collided:
		if polygon != null and Geometry.is_point_in_polygon(get_local_mouse_position(), polygon.polygon):
			get_parent()._collided()
			collided = true
	
	if not get_viewport_rect().grow(100).has_point(position):
		queue_free()
