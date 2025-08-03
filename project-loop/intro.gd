extends Node2D

@onready var _1: Sprite2D = $"1"
@onready var _2: Sprite2D = $"2"
@onready var _3: Sprite2D = $"3"
@onready var _4: Sprite2D = $"4"
@onready var _5: Sprite2D = $"5"
@onready var _6: Sprite2D = $"6"
@onready var end_timer: Timer = $"End timer"

@onready var pages: Array = [_1, _2, _3, _4, _5, _6]

var current_page := 0
var is_turning := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Page_turn") and not is_turning:
		if current_page < pages.size():
			turn_page(pages[current_page])
			is_turning = true
		else:
			print("No more pages to turn.")
			get_tree().change_scene_to_file("res://Scenes/level.tscn")

func turn_page(page: Sprite2D):
	var tween := create_tween()
	tween.tween_property(page.material, "shader_parameter/progress", 1.0, 2.0)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	current_page += 1
	is_turning = false


func _on_end_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
	pass # Replace with function body.
