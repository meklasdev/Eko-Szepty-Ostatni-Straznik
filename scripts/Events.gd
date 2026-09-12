extends Node

# Central Signal Bus for "Eko-Szepty: Ostatni Strażnik"

signal player_energy_changed(player_id: int, current: float, max_energy: float)
signal player_died(player_id: int)
signal sanctuary_charged(sanctuary_id: String)
signal game_over
signal game_won
