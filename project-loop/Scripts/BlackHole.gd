extends Area2D
class_name BlackHole

@export var growth_rate: float = 0.50

@onready var visual_root: Node2D = $BlackHole
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var initial_scale: Vector2
var initial_radius: float = 0.0

func _ready() -> void:
	initial_scale = scale
	
	var shape_resource = collision_shape.shape
	if shape_resource is CircleShape2D:
		initial_radius = shape_resource.radius

func _process(delta: float) -> void:
	scale_blackhole(growth_rate * delta)
	
func reset():
	if visual_root:
		visual_root.scale = initial_scale  # <- Fix: Reset visual scale

	var shape_resource = collision_shape.shape
	if shape_resource is CircleShape2D:
		shape_resource.radius = initial_radius  # Replace with actual original size

func grow():
	print("Black hole grew!")
	scale_blackhole(growth_rate)

func scale_blackhole(amount: float) -> void:
	# Scale visuals
	if visual_root:
		visual_root.scale += Vector2.ONE * amount
	
	# Scale the collision shape
	if collision_shape and collision_shape.shape:
		var shape = collision_shape.shape
		if shape is CircleShape2D:
			shape.radius *= 1.0 + amount
		
