class_name FogFlower
extends Node2D

@onready var area: Area2D = $Area2D

func _ready() -> void:
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.fog_count += 1

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.fog_count -= 1
