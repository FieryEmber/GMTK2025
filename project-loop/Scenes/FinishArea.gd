extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mobius:
		print("hit2")
		get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	pass # Replace with function body.
