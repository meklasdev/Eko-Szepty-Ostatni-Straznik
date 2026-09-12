class_name Player
extends CharacterBody2D

@export var player_id: int = 1
@export var speed: float = 200.0
@export var max_energy: float = 100.0
@export var energy_drain_rate: float = 2.0
@export var flash_cost: float = 25.0
@export var plant_cost: float = 15.0

var current_energy: float = 100.0
var is_dead: bool = false
var is_hidden: bool = false
var fog_count: int = 0:
	set(val):
		fog_count = max(0, val)
		is_hidden = (fog_count > 0)

var current_speed_bonus: float = 0.0
var speed_boost_timer: float = 0.0

@onready var light: PointLight2D = get_node_or_null("PointLight2D")
@onready var flash_area: Area2D = get_node_or_null("FlashArea")

var spring_mushroom_scene: PackedScene = preload("res://scenes/SpringMushroom.tscn")
var fog_flower_scene: PackedScene = preload("res://scenes/FogFlower.tscn")

func _ready() -> void:
	add_to_group("Players")
	current_energy = max_energy

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if speed_boost_timer > 0.0:
		speed_boost_timer -= delta
		if speed_boost_timer <= 0.0:
			current_speed_bonus = 0.0

	handle_movement()
	handle_energy_and_light(delta)
	handle_inputs()

func apply_speed_boost(amount: float, duration: float) -> void:
	current_speed_bonus = amount
	speed_boost_timer = duration

func handle_movement() -> void:
	var left_action := "p%d_left" % player_id
	var right_action := "p%d_right" % player_id
	var up_action := "p%d_up" % player_id
	var down_action := "p%d_down" % player_id

	var input_dir := Input.get_vector(left_action, right_action, up_action, down_action)
	velocity = input_dir * (speed + current_speed_bonus)
	move_and_slide()

func handle_energy_and_light(delta: float) -> void:
	var drain_multiplier := 1.0
	var is_tethered := false

	# Light Tether mechanic: check distance to other players
	var players := get_tree().get_nodes_in_group("Players")
	for p in players:
		if p != self and p is Player and not p.is_dead:
			if global_position.distance_to(p.global_position) < 150.0:
				drain_multiplier = 0.5
				is_tethered = true
				# Energy equalization: smoothly move current_energy towards partner's current_energy
				if current_energy < p.current_energy:
					current_energy += (p.current_energy - current_energy) * 0.5 * delta
				break

	current_energy -= energy_drain_rate * drain_multiplier * delta
	current_energy = clamp(current_energy, 0.0, max_energy)

	Events.player_energy_changed.emit(player_id, current_energy, max_energy)

	if current_energy <= 0.0 and not is_dead:
		is_dead = true
		Events.player_died.emit(player_id)
		_check_game_over()

	if light:
		var tether_boost := 1.3 if is_tethered else 1.0
		light.energy = (current_energy / max_energy) * 1.5 * tether_boost
		light.texture_scale = max(0.2, (current_energy / max_energy) * 1.0 * tether_boost)

func _check_game_over() -> void:
	var players := get_tree().get_nodes_in_group("Players")
	var all_dead := true
	for p in players:
		if p is Player and not p.is_dead:
			all_dead = false
			break
	if all_dead:
		Events.game_over.emit()

func handle_inputs() -> void:
	var flash_action := "p%d_flash" % player_id
	var plant_action := "p%d_plant" % player_id

	if Input.is_action_just_pressed(flash_action):
		use_flash()

	if Input.is_action_just_pressed(plant_action):
		plant_seed()

func use_flash() -> void:
	if current_energy >= flash_cost:
		current_energy -= flash_cost
		if flash_area:
			var targets := flash_area.get_overlapping_bodies() + flash_area.get_overlapping_areas()
			for target in targets:
				if target != self and target.has_method("stun"):
					target.stun(3.0)

func plant_seed() -> void:
	if current_energy >= plant_cost:
		current_energy -= plant_cost
		var scene_to_plant: PackedScene = spring_mushroom_scene if player_id == 1 else fog_flower_scene
		if scene_to_plant:
			var plant_inst = scene_to_plant.instantiate()
			plant_inst.global_position = global_position
			get_parent().add_child(plant_inst)
