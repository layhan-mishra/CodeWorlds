extends CharacterBody2D

signal encountered

@export var speed: float = 120.0
@export var step_distance: float = 16.0      # pixels walked between encounter rolls
@export var encounter_chance: float = 0.1    # chance per roll


var can_move: bool = true
var _grass_count: int = 0
var _distance_since_roll: float = 0.0
var _facing: String = "down"
var _anim_time: float = 0.0

const COLS: int = 6
const WALK_FPS: float = 10.0
const IDLE_FPS: float = 4.0
const IDLE_ROWS := {"down": 0, "side": 1, "up": 2}
const WALK_ROWS := {"down": 3, "side": 4, "up": 5}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	$Camera2D.zoom = Vector2(3,3)

func enter_grass() -> void:
	_grass_count += 1

func exit_grass() -> void:
	_grass_count = max(_grass_count - 1, 0)

func _physics_process(delta: float) -> void:
	if not can_move:
		_update_animation(Vector2.ZERO, delta)
		return

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()
	_update_animation(dir, delta)


	if _grass_count > 0 and dir != Vector2.ZERO:
		_distance_since_roll += get_real_velocity().length() * delta
		if _distance_since_roll >= step_distance:
			_distance_since_roll = 0.0
			if randf() < encounter_chance:
				encountered.emit()

func _update_animation(dir: Vector2, delta: float) -> void:
	var moving: bool = dir != Vector2.ZERO
	if moving:
		if absf(dir.x) > absf(dir.y):
			_facing = "side"
			sprite.flip_h = dir.x < 0.0
		else:
			_facing = "up" if dir.y < 0.0 else "down"

	var row: int = WALK_ROWS[_facing] if moving else IDLE_ROWS[_facing]
	var fps: float = WALK_FPS if moving else IDLE_FPS
	_anim_time += delta * fps
	sprite.frame = row * COLS + (int(_anim_time) % COLS)
