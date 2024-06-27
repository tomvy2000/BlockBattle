extends Node

@export var player: Player
@export var enemy: Enemy

var item_pieces: Array[ItemPiece] = []

func _ready() -> void:
	player = get_tree().root.get_node("Main/Player")
	enemy = get_tree().root.get_node("Main/Enemy")
	
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
	
				
	
func add_item_piece(item_piece: ItemPiece) -> void:
	item_pieces.append(item_piece)
