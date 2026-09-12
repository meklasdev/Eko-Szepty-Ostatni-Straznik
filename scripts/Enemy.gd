class_name Enemy
extends CharacterBody2D

enum State { PATROL, CHASE, STUNNED }

@export var current_state: State = State.PATROL
@export var patrol_points: Array[Node2D] = []
@export var speed: float = 100.0
@export var chase_speed: float = 150.0

var current_patrol_index: int = 0
var stun_timer: float = 0.0
var target_player: Player = null

@onready var vision_area: Area2D = get_node_or_null("VisionArea")
@onready var raycast: RayCast2D = get_node_or_null("RayCast2D")

func _ready() -> void:
	add_to_group("Enemies")

func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			process_patrol(delta)
			check_for_players()
			check_player_collision()
		State.CHASE:
			process_chase(delta)
			check_for_players()
			check_player_collision()
		State.STUNNED:
			process_stunned(delta)

func process_patrol(delta: float) -> void:
	if patrol_points.is_empty():
		velocity = Vector2.ZERO
		return

	var target_point := patrol_points[current_patrol_index]
	if target_point == null or not is_instance_valid(target_point):
		return

	var direction := (target_point.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if global_position.distance_to(target_point.global_position) < 10.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()

func process_chase(delta: float) -> void:
	if target_player == null or not is_instance_valid(target_player):
		current_state = State.PATROL
		return

	var direction := (target_player.global_position - global_position).normalized()
	velocity = direction * chase_speed
	move_and_slide()

func process_stunned(delta: float) -> void:
	velocity = Vector2.ZERO
	stun_timer -= delta
	if stun_timer <= 0.0:
		current_state = State.PATROL

func check_for_players() -> void:
	if vision_area == null:
		return

	var detected_player: Player = null
	var bodies := vision_area.get_overlapping_bodies()

	for body in bodies:
		if body is Player:
			# Check stealth flag
			if body.is_hidden:
				continue

			# Check line of sight using RayCast2D
			if raycast:
				raycast.global_position = global_position
				raycast.target_position = raycast.to_local(body.global_position)
				raycast.force_raycast_update()

				if raycast.is_colliding():
					var collider = raycast.get_collider()
					if collider == body:
						detected_player = body
						break
			else:
				detected_player = body
				break

	if detected_player != null:
		target_player = detected_player
		current_state = State.CHASE
	else:
		if current_state == State.CHASE:
			current_state = State.PATROL
			target_player = null

func check_player_collision() -> void:
	if current_state == State.STUNNED:
		return

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Player:
			collider.current_energy = 0.0
			Events.player_died.emit(collider.player_id)
			_check_game_over()
			return

	if target_player and is_instance_valid(target_player) and current_state == State.CHASE:
		if global_position.distance_to(target_player.global_position) < 25.0:
			target_player.current_energy = 0.0
			Events.player_died.emit(target_player.player_id)
			_check_game_over()

func _check_game_over() -> void:
	var players := get_tree().get_nodes_in_group("Players")
	var all_dead := true
	for p in players:
		if p is Player and p.current_energy > 0.0:
			all_dead = false
			break
	if all_dead:
		Events.game_over.emit()

func stun(duration: float) -> void:
	stun_timer = duration
	current_state = State.STUNNED
