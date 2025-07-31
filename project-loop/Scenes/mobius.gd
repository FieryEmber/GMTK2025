extends CharacterBody2D

@export var SPEED = 150
@export var JUMP_VELOCITY = -300
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta):
	velocity.y += GRAVITY * delta

	var is_moving = false
	velocity.x = 0

	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		is_moving = true
		anim.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		is_moving = true
		anim.flip_h = false
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
		elif is_moving:
			anim.play("walking")
			animation_player.play("Run_skew")
		else:
			anim.play("idle")
	else:
		if velocity.y > 0:
			anim.play("falling")
		else:
			anim.play("jump")
			animation_player.play("Jump_skew")

	move_and_slide()
