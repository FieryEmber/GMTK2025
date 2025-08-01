extends Control

@onready var up: Button = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Up
@onready var teleport: Button = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Teleport
@onready var left: Button = $MarginContainer/VBoxContainer2/HBoxContainer/Left
@onready var down: Button = $MarginContainer/VBoxContainer2/HBoxContainer/Down
@onready var right: Button = $MarginContainer/VBoxContainer2/HBoxContainer/Right

@onready var mobius: CharacterBody2D = $"../../../Mobius"
