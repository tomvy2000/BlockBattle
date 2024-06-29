extends Node

@export var player: Player
@export var board: Board
@export var item_spawner: ItemSpawner
var enemy_spawner: EnemySpawner

signal new_turn_began()

var battle_ui_scene = preload("res://_main/scenes/battle_ui.tscn")
var battle_ui: BattleUI

var item_pieces: Array[ItemPiece] = []
var alive_enemies: Array[Enemy] = []
## Action points received each turn
var action_point = 5
## Max action points each turn, can be increased
var max_action_point = 5
## Current level
var level = 1

var current_enemy: Enemy:
	set(value):
		if current_enemy != null:
			current_enemy.indicator.visible = false
		current_enemy = value
		if current_enemy != null:
			current_enemy.indicator.visible = true

func _ready() -> void:
	var canvas = get_tree().root.get_node("Main/CanvasLayer")
	battle_ui = battle_ui_scene.instantiate()
	canvas.add_child(battle_ui)
	battle_ui.end_turn_button.pressed.connect(end_turn)
	battle_ui.update_ap_label()
	board = battle_ui.board
	
	player = get_tree().root.get_node("Main/Player")
	
	item_spawner = get_tree().root.get_node("Main/ItemSpawner")
	item_spawner.item_container = battle_ui.item_container
	enemy_spawner = get_tree().root.get_node("Main/EnemySpawner")
	enemy_spawner.viewport_size = get_viewport().size
	enemy_spawner.spawn(2)
	current_enemy = alive_enemies[0]
	
	new_turn_began.connect(item_spawner.new_turn)
	new_turn_began.connect(player.new_turn)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_A:
		if event.is_pressed():
			activate_item_pieces()
	
func activate_item_pieces() -> void:
	var attack = 0
	var heal = 0
	var shield = 0
	for piece in item_pieces:
		attack += piece.item_data.attack
		heal += piece.item_data.heal
		shield += piece.item_data.shield
		for block in piece.active_blocks:
			var tile = block.hovered_tile
			if piece.item_data.type == ItemData.ItemType.WEAPON and tile.tile_type == Tile.TYPE.ATTACK:
				attack += 5
			elif piece.item_data.type == ItemData.ItemType.ARMOR and tile.tile_type == Tile.TYPE.DEFEND:
				shield += 5
			elif piece.item_data.type == ItemData.ItemType.HEAL and tile.tile_type == Tile.TYPE.HEAL:
				heal += 5
	player.attack(current_enemy, attack)
	player.heal(heal)
	player.shield_up(shield)
	
	
func end_turn() -> void:
	battle_ui.end_turn_button.visible = false
	activate_item_pieces()
	for item in item_pieces:
		item.queue_free()
	item_pieces.clear()
	await play_enemy_turn()
	await get_tree().create_timer(1).timeout
	await new_turn()
	
	
func new_turn() -> void:
	action_point = max_action_point
	battle_ui.end_turn_button.visible = true
	await board.refill_board()
	
	new_turn_began.emit()
	
func play_enemy_turn() -> void:
	for enemy in alive_enemies:
		await enemy.play_turn(player)

func add_item_piece(item_piece: ItemPiece) -> void:
	item_pieces.append(item_piece)

func change_action_point(amount: int):
	action_point += amount
	if action_point < 0:
		action_point = 0
	elif action_point > max_action_point:
		action_point = max_action_point
	battle_ui.update_ap_label()
	
func add_enemy(enemy: Enemy) -> void:
	alive_enemies.append(enemy)
	enemy.dead.connect(remove_enemy)
	
func remove_enemy(enemy: Enemy) -> void:
	alive_enemies.erase(enemy)
	if enemy == current_enemy and alive_enemies.size() > 0:
		current_enemy = alive_enemies[0]
	enemy.queue_free()

