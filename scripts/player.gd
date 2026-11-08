extends CharacterBody2D

signal encountered

@export var speed: float = 120.0
@export var step_distance: float = 16.0      # pixels walked between encounter rolls
@export var encounter_chance: float = 0.1    # chance per roll

var can_move: bool = true
var _grass_count: int = 0
var _distance_since_roll: float = 0.0

func enter_grass() -> void:
	_grass_count += 1

func exit_grass() -> void:
	_grass_count = max(_grass_count - 1, 0)

func _physics_process(delta: float) -> void:
	if not can_move:
		return

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()

	if _grass_count > 0 and dir != Vector2.ZERO:
		_distance_since_roll += get_real_velocity().length() * delta
		if _distance_since_roll >= step_distance:
			_distance_since_roll = 0.0
			if randf() < encounter_chance:
				encountered.emit()