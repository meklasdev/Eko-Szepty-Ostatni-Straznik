class_name Player
extends CharacterBody2D

@export var player_id: int = 1
@export var speed: float = 200.0
@export var max_energy: float = 100.0
@export var energy_drain_rate: float = 2.0
@export var flash_cost: float = 25.0
@export var plant_cost: float = 15.0

var current_energy: float = 100.0
var is_hidden: bool = false

@onready var light: PointLight2D = get_node_or_null("PointLight2D")
@onready var flash_area: Area2D = get_node_or_null("FlashArea")

var plant_scene: PackedScene = preload("res://scenes/PlantBase.tscn")

func _ready() -> void:
	add_to_group("Players")
	current_energy = max_energy

func _physics_process(delta: float) -> void:
	handle_movement()
	handle_energy_and_light(delta)
	handle_inputs()

func handle_movement() -> void:
	var left_action := "p%d_left" % player_id
	var right_action := "p%d_right" % player_id
	var up_action := "p%d_up" % player_id
	var down_action := "p%d_down" % player_id

	var input_dir := Input.get_vector(left_action, right_action, up_action, down_action)
	velocity = input_dir * speed
	move_and_slide()

func handle_energy_and_light(delta: float) -> void:
	var drain_multiplier := 1.0

	# Light Tether mechanic: check distance to other players
	var players := get_tree().get_nodes_in_group("Players")
	for p in players:
		if p != self and p is Player:
			if global_position.distance_to(p.global_position) < 150.0:
				drain_multiplier = 0.5
				break

	current_energy -= energy_drain_rate * drain_multiplier * delta
	current_energy = clamp(current_energy, 0.0, max_energy)

	Events.player_energy_changed.emit(player_id, current_energy, max_energy)

	if current_energy <= 0.0:
		Events.player_died.emit(player_id)

	if light:
		light.energy = (current_energy / max_energy) * 1.5
		light.texture_scale = max(0.2, (current_energy / max_energy) * 1.0)

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
		if plant_scene:
			var plant_inst = plant_scene.instantiate()
			plant_inst.global_position = global_position
			get_parent().add_child(plant_inst)
