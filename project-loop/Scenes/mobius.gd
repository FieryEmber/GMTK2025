extends CharacterBody2D


@export var SPEED = 180
@export var JUMP_VELOCITY = -400

@onready var start_delaytimer = $StartDelayTimer
@onready var game_loop_timer = $GameLoopTimer

var game_time_remaining = 30
var countdown_started = false
var delay_started = false
var spawn_position = Vector2.ZERO

const GRAVITY = 900
const JUMP_CUT_MULTIPLIER = 0.2
const MAX_JUMPS = 2

@onready var anim = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var jump_count = 0

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if is_on_floor() and not delay_started and not countdown_started:
		start_delaytimer.start()
		delay_started = true

	var is_moving = false
	velocity.x = 0

	# Horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED
		is_moving = true
		anim.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x += SPEED
		is_moving = true
		anim.flip_h = false
	else:
		velocity.x = 0

	# Jump
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS-1:
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		jump_count += 1

	# Variable jump height
	if velocity.y < 0 and Input.is_action_just_released("jump"):
		velocity.y *= JUMP_CUT_MULTIPLIER
		
	# Teleport
	#if Input.is_action_just_pressed("teleport"):
		#self.position = get_global_mouse_position()
		#self.velocity.y = 0

	# Reset jump count when on floor
	if is_on_floor():
		jump_count = 0
		if is_moving:
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


func _on_game_loop_timer_timeout() -> void:
	game_time_remaining -= 1;
	
	if game_time_remaining <= 0:
		game_loop_timer.stop()
		global_position = spawn_position
		velocity = Vector2.ZERO
		delay_started = false
		countdown_started = false


func _on_start_delay_timer_timeout() -> void:
	game_time_remaining = 30
	game_loop_timer.start()
	countdown_started = true
