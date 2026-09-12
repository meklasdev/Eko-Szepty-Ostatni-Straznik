class_name HUD
extends CanvasLayer

@onready var p1_bar: ProgressBar = $Control/P1EnergyBar
@onready var p2_bar: ProgressBar = $Control/P2EnergyBar
@onready var game_over_panel: Control = $Control/GameOverPanel
@onready var win_panel: Control = $Control/WinPanel
@onready var restart_button_go: Button = $Control/GameOverPanel/RestartButton
@onready var restart_button_win: Button = $Control/WinPanel/RestartButton

func _ready() -> void:
	if game_over_panel:
		game_over_panel.visible = false
	if win_panel:
		win_panel.visible = false

	Events.player_energy_changed.connect(_on_player_energy_changed)
	Events.game_over.connect(_on_game_over)
	Events.game_won.connect(_on_game_won)

	if restart_button_go:
		restart_button_go.pressed.connect(_on_restart_pressed)
	if restart_button_win:
		restart_button_win.pressed.connect(_on_restart_pressed)

func _on_player_energy_changed(player_id: int, current: float, max_energy: float) -> void:
	var pct := (current / max_energy) * 100.0
	if player_id == 1 and p1_bar:
		p1_bar.value = pct
	elif player_id == 2 and p2_bar:
		p2_bar.value = pct

func _on_game_over() -> void:
	if game_over_panel:
		game_over_panel.visible = true

func _on_game_won() -> void:
	if win_panel:
		win_panel.visible = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
