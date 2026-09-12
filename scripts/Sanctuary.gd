class_name Sanctuary
extends Area2D

@export var sanctuary_id: String = "Sanctuary_1"
@export var charge_amount: float = 0.0
@export var max_charge: float = 100.0
@export var charge_rate: float = 25.0

var is_fully_charged: bool = false

func _ready() -> void:
	add_to_group("Sanctuaries")

func _physics_process(delta: float) -> void:
	if is_fully_charged:
		return

	var bodies := get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			var interact_action := "p%d_interact" % body.player_id
			if Input.is_action_pressed(interact_action):
				# Transfer energy from player to sanctuary
				# Player 2 (Moon) charges 2x faster / more efficiently
				var efficiency := 2.0 if body.player_id == 2 else 1.0
				var transfer := charge_rate * efficiency * delta
				if body.current_energy > transfer:
					body.current_energy -= transfer
					charge_amount += transfer
					if charge_amount >= max_charge:
						charge_amount = max_charge
						is_fully_charged = true
						Events.sanctuary_charged.emit(sanctuary_id)
						_check_all_sanctuaries_charged()
						break

func _check_all_sanctuaries_charged() -> void:
	var sanctuaries := get_tree().get_nodes_in_group("Sanctuaries")
	var all_charged := true
	for s in sanctuaries:
		if s is Sanctuary and not s.is_fully_charged:
			all_charged = false
			break
	if all_charged:
		Events.game_won.emit()
