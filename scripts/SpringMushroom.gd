class_name SpringMushroom
extends Node2D

@export var boost_amount: float = 150.0
@export var boost_duration: float = 2.0
@export var max_uses: int = 3

var uses_left: int = 3

@onready var area: Area2D = $Area2D

func _ready() -> void:
	uses_left = max_uses
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_method("apply_speed_boost"):
			body.apply_speed_boost(boost_amount, boost_duration)
			uses_left -= 1
			if uses_left <= 0:
				queue_free()
