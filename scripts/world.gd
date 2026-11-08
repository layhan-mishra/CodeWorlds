extends Node2D

const BATTLE_SCENE := preload("res://scenes/battle.tscn")

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	player.encountered.connect(_on_player_encountered)

func _on_player_encountered() -> void:
	player.can_move = false
	var battle := BATTLE_SCENE.instantiate()
	battle.battle_finished.connect(_on_battle_finished)
	add_child(battle)

func _on_battle_finished(_won: bool) -> void:
	player.can_move = true