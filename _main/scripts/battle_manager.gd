extends Node

@export var player: Player
@export var enemy: Enemy
@export var item_spawner: ItemSpawner


var battle_ui_scene = preload("res://_main/scenes/battle_ui.tscn")

var item_pieces: Array[ItemPiece] = []
var action_point = 1
var max_action_point = 1
var level = 1

func _ready() -> void:
	var canvas = get_tree().root.get_node("Main/CanvasLayer")
	var battle_ui: BattleUI = battle_ui_scene.instantiate()
	canvas.add_child(battle_ui)
	battle_ui.end_turn_button.pressed.connect(end_turn)
	
	player = get_tree().root.get_node("Main/Player")
	enemy = get_tree().root.get_node("Main/Enemy")
	item_spawner = get_tree().root.get_node("Main/ItemSpawner")
	item_spawner.item_container = battle_ui.item_container
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_A:
		if event.is_pressed():
			activate_item_pieces()
	
func activate_item_pieces() -> void:
	var attack = 0
	var heal = 0
	var shield = 0
	for piece in item_pieces:
		for block in piece.active_blocks:
			var tile = block.hovered_tile
			if piece.item_data.type == ItemData.ItemType.WEAPON and tile.tile_type == Tile.TYPE.ATTACK:
				attack += 5
			elif piece.item_data.type == ItemData.ItemType.ARMOR and tile.tile_type == Tile.TYPE.DEFEND:
				shield += 5
			elif piece.item_data.type == ItemData.ItemType.HEAL and tile.tile_type == Tile.TYPE.HEAL:
				heal += 5
	player.attack(enemy, attack)
	player.heal(heal)
	player.shield_up(shield)
	
func end_turn() -> void:
	activate_item_pieces()
				
	
func add_item_piece(item_piece: ItemPiece) -> void:
	item_pieces.append(item_piece)
