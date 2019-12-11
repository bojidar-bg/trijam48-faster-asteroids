extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var points = PoolVector2Array()
	points.resize(5 - get_index())
	for i in range(points.size()):
		points[i] = Vector2(10, 0).rotated(2 * PI * i / points.size() - PI / 2)
	polygon = points


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
