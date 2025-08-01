extends CharacterBody2D

class_name Mobius

@export var SPEED = 190
@export var JUMP_VELOCITY = -400

@onready var start_delaytimer = $StartDelayTimer
@onready var game_loop_timer = $GameLoopTimer

var game_time_remaining = 24
var countdown_started = false
var delay_started = false
var spawn_position = Vector2.ZERO
var spawn_position_2 = Vector2(-100, 0)
var loop_started = false

# Mobius allowed movement
var can_move_right = true
var can_move_left = false
var can_move_down = false
var can_jump = false 
var can_double_jump = false
var can_teleport = false

const GRAVITY = 900
const JUMP_CUT_MULTIPLIER = 0.2
const MAX_JUMPS = 2

@onready var anim = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var black_hole := $"../Tilemap/Area2D" as BlackHole

var jump_count = 0

func _ready() -> void:
	spawn_position = global_position
	start_delaytimer.start()
	delay_started = true

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	var is_moving = false
	velocity.x = 0

	# Horizontal movement
	if Input.is_action_pressed("right") and can_move_right:
		velocity.x += SPEED
		is_moving = true
		anim.flip_h = false
	elif Input.is_action_pressed("left") and can_move_left:
		velocity.x -= SPEED
		is_moving = true
		anim.flip_h = true
	else: 
		velocity.x = 0

	# Jump
	if Input.is_action_just_pressed("jump") and can_jump:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			jump_count = 1
		elif can_double_jump and jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			jump_count += 1
		
	# Variable jump height
	if velocity.y < 0 and Input.is_action_just_released("jump"):
		velocity.y *= JUMP_CUT_MULTIPLIER
		
	#Teleport
	if Input.is_action_just_pressed("teleport") and can_teleport:
		self.position = get_global_mouse_position()
		self.velocity.y = 0

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

func unlock_from_piece(piece: HelmetPiece) -> void:
	if piece.unlock_left:
		can_move_left = true
	if piece.unlock_jump:
		can_jump = true;
	if piece.unlock_double_jump:
		can_double_jump = true
	if piece.unlock_teleport:
		can_teleport = true

func _on_game_loop_timer_timeout() -> void:
	game_time_remaining -= 1;
	
	if game_time_remaining <= 0:
		game_loop_timer.stop()
		global_position = spawn_position
		velocity = Vector2.ZERO
		delay_started = false
		countdown_started = false
		loop_started = false
		black_hole.reset()
		start_delaytimer.start()


func _on_start_delay_timer_timeout() -> void:
	if loop_started:
		return
	
	black_hole.grow()
		
	loop_started = true
	game_time_remaining = 30
	game_loop_timer.start()
	countdown_started = true

func reset_player_position() -> void:
	if can_move_left or can_jump or can_double_jump:
		global_position = spawn_position_2
	elif can_move_right or can_teleport:
		global_position = spawn_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		reset_player_position()
		velocity = Vector2.ZERO
		black_hole.reset()
		black_hole.growth_rate = 0.20


func _on_helmet_piece_piece_collected(piece: HelmetPiece) -> void:
	unlock_from_piece(piece)
	black_hole.growth_rate = 0.60
