extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_grass"):
		body.enter_grass()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("exit_grass"):
		body.exit_grass()
