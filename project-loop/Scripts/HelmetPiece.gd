extends Area2D

class_name HelmetPiece

@export var unlock_left: bool = false
@export var unlock_move_down = false
@export var unlock_jump: bool = false
@export var unlock_double_jump: bool = false
@export var unlock_teleport: bool = false

@export var new_spawn_position: Vector2 = Vector2.ZERO

signal piece_collected(piece: HelmetPiece)

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body: Node) -> void:
	if body is Mobius:
		emit_signal("piece_collected", self)
		queue_free()
