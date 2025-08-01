extends Area2D
class_name BlackHole

@onready var visual_root: Node2D = $BlackHole
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var growth_rate: float = 0.0
var active: bool = false
var initial_scale: Vector2
var initial_radius: float = 0.0
var total_growth_factor: float = 1.0

func _ready() -> void:
	initial_scale = visual_root.scale
	var shape_resource = collision_shape.shape
	if shape_resource is CircleShape2D:
		initial_radius = shape_resource.radius
		
func _process(delta: float) -> void:
	if not active:
		return

	var growth = 1.0 + (growth_rate * delta)
	total_growth_factor *= growth
	apply_growth()
	
func start_growing(rate: float) -> void:
	if active:
		return
	growth_rate = rate
	active = true
	
func grow_by(rate: float) -> void:
	if rate == 0.0:
		return
		
	growth_rate = rate
	total_growth_factor *= (1.0 + growth_rate)
	apply_growth()

func reset():
	total_growth_factor = 1.0
	growth_rate = 0.0
	apply_growth()
	
func apply_growth():
	# Scale visual sprite
	visual_root.scale = initial_scale * total_growth_factor

	# Scale collision shape radius
	var shape = collision_shape.shape
	if shape is CircleShape2D:
		shape.radius = initial_radius * total_growth_factor

func stop_growing() -> void:
	active = false
