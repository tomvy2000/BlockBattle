class_name BattleUI
extends Control

@export var board: Board
@export var ap_label: Label
@export var end_turn_button: Button
@export var item_container: Control
@export var level_label: Label

func update_ap_label() -> void:
	ap_label.text = "%s/%s" % [BattleManager.action_point, BattleManager.max_action_point]
	
func update_level_label() -> void:
	level_label.text = "Room: %s" % [BattleManager.level + 1]
