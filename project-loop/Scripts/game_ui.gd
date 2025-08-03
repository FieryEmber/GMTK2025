extends Control

@onready var up: Button = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Up
@onready var teleport: Button = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Teleport
@onready var left: Button = $MarginContainer/VBoxContainer2/HBoxContainer/Left
@onready var down: Button = $MarginContainer/VBoxContainer2/HBoxContainer/Down
@onready var right: Button = $MarginContainer/VBoxContainer2/HBoxContainer/Right

@onready var mobius: CharacterBody2D = $"../../../Mobius"

func _process(delta: float) -> void:
	
	if mobius.can_move_right:
		right.disabled = false
	if not mobius.can_move_right:
		right.disabled = true
		pass
	
	if mobius.can_move_left:
		left.disabled = false
	if not mobius.can_move_left:
		left.disabled = true
		pass
	
	if mobius.can_move_down:
		down.disabled = false
	if not mobius.can_move_down:
		down.disabled = true
		pass
	
	if mobius.can_jump:
		up.disabled = false
	if not mobius.can_jump:
		up.disabled = true
		pass
	
	if mobius.can_teleport:
		teleport.disabled = false
	if not mobius.can_teleport:
		teleport.disabled = true
		pass
