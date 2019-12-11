extends Node2D

var level_size = 350
var velocity = 100.0
var density_increase = 0.0000001
var initial_density = 0.0003
var asteroid_velocity_increase = 0.03
var asteroid_angular_velocity_increase = 0.001
var distance = -7
onready var pivot = $Pivot
onready var progress = $GUI/Progress
onready var progress_label = $GUI/Progress/Label

func _ready():
	Input.warp_mouse_position(get_viewport().size / 2)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(delta):
	if distance < 0:
		progress.value = 0
		progress_label.text = ""
	
		distance += velocity * delta
		if distance > 0:
			velocity = 0.2
			var asteroid = preload("res://InitialHelp.tscn").instance()
			asteroid.position = Vector2(0.5, 0.5) * get_viewport().size
			asteroid.depth = 1
			add_child_below_node(pivot, asteroid)
			asteroid.step(randf() * delta)
		return
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		velocity += delta
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		velocity *= pow(0.25, delta)
		velocity = max(velocity, 0.01)
	
	distance += velocity * delta
	
	var density = density_increase * distance + initial_density
	var volume = velocity * delta * get_viewport_rect().get_area()
	for i in min(floor(volume * density + randf()), 256):
		var asteroid = preload("res://Asteroid.tscn").instance()
		asteroid.position = Vector2(randf(), randf()) * get_viewport().size
		asteroid.angular_velocity = (randf() - 0.5) * 2 * asteroid_angular_velocity_increase * distance
		asteroid.velocity = Vector2(asteroid_velocity_increase * distance * randf(), 0).rotated(2 * PI * randf())
		add_child_below_node(pivot, asteroid)
		asteroid.step(randf() * delta)
	
	progress.value = fmod(distance, level_size) / level_size * 100
	if distance > level_size:
		progress_label.text = str("Level: ", int(distance / level_size))

func _collided():
	if distance > 0:
		velocity /= 2
		for child in $GUI/Health.get_children():
			if child.visible:
				child.visible = false
				return
		
		if fmod(distance, level_size) > level_size / 2:
			distance -= level_size / 2
			return
		
		
		for child in $GUI/Health.get_children():
			child.visible = true
		distance = -7.5
		velocity = 50
