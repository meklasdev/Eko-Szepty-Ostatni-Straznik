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
				var transfer := charge_rate * delta
				if body.current_energy > transfer:
					body.current_energy -= transfer
					charge_amount += transfer
					if charge_amount >= max_charge:
						charge_amount = max_charge
						is_fully_charged = true
						Events.sanctuary_charged.emit(sanctuary_id)
						break
