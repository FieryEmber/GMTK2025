extends CharacterBody2D

class_name Mobius

@export var SPEED = 190
@export var JUMP_VELOCITY = -400

var spawn_position = Vector2.ZERO
var spawn_position_2 = Vector2(-100, 0)
var spawn_checkpoint = 0
var loop_started = false
var black_hole_active = false

# Mobius allowed movement
var can_move_right = true
var can_move_left = false
var can_move_down = false
var can_jump = false 
var can_double_jump = false
var can_teleport = false
var started_input = false

const GRAVITY = 900
const JUMP_CUT_MULTIPLIER = 0.2
const MAX_JUMPS = 2

@onready var anim = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var black_hole := $"../Tilemap/Area2D" as BlackHole

var jump_count = 0

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var is_moving = false
	velocity.x = 0

	# Horizontal movement
	if Input.is_action_pressed("right") and can_move_right:
		velocity.x += SPEED
		is_moving = true
		anim.flip_h = false
		started_input = true
	elif Input.is_action_pressed("left") and can_move_left:
		velocity.x -= SPEED
		is_moving = true
		anim.flip_h = true
		started_input = true
	else: 
		velocity.x = 0
	
	if Input.is_action_pressed("down") and can_move_down:
		velocity.y += 50  
		move_and_slide()  
		

	# Jump
	if Input.is_action_just_pressed("jump") and can_jump:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			jump_count = 1
			started_input = true
		elif can_double_jump and jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			jump_count += 1
			started_input = true
		
	# Variable jump height
	if velocity.y < 0 and Input.is_action_just_released("jump"):
		velocity.y *= JUMP_CUT_MULTIPLIER
		
	#Teleport
	if Input.is_action_just_pressed("teleport") and can_teleport:
		self.position = get_global_mouse_position()
		self.velocity.y = 0
		started_input = true
		
	if started_input and not black_hole_active:
		black_hole_active = true
		var rate = get_dynamic_growth_rate()
		black_hole.start_growing(rate)

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
	if piece.unlock_move_down:
		can_move_down = true
	if piece.unlock_jump:
		can_jump = true
	if piece.unlock_double_jump:
		can_jump = true
	if piece.unlock_teleport:
		can_teleport = true
		
func get_dynamic_growth_rate() -> float:
	var base_rate = 0.20
	
	if can_move_left:
		base_rate -= 0.05
		
	if can_move_down:
		base_rate -= 0.05
	
	if can_jump:
		base_rate -= 0.10
	
	if can_double_jump:
		base_rate -= 0.10
	
	if can_teleport:
		base_rate -= 0.10
		
	return base_rate

func reset_player_position() -> void:
	match spawn_checkpoint:
		0: global_position = spawn_position      
		1: global_position = spawn_position_2    
		2: global_position = spawn_position       
		3: global_position = spawn_position_2     
		_: global_position = spawn_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		reset_player_position()
		velocity = Vector2.ZERO
		black_hole.reset()
		black_hole.stop_growing()
		black_hole_active = false


func _on_helmet_piece_piece_collected(piece: HelmetPiece) -> void:
	unlock_from_piece(piece)
	black_hole.growth_rate = 0.60
	spawn_checkpoint = 1

func _on_helmet_piece_2_piece_collected(piece: HelmetPiece) -> void:
	unlock_from_piece(piece)
	black_hole.growth_rate = 0.60
	spawn_checkpoint = 2

func _on_helmet_piece_3_piece_collected(piece: HelmetPiece) -> void:
	unlock_from_piece(piece)
	black_hole.growth_rate = 0.60
	spawn_checkpoint = 3
