class_name ItemPiece
extends Control

@export var item_data: ItemData
@export var texture: Texture
@export var shape: Array[Vector2i]
@export var width: int
@export var height: int

@onready var icon_container: PanelContainer = $IconContainer
@onready var block_container = %BlockContainer

const PIECE_BLOCK = preload("res://_main/scenes/piece_block.tscn")
const BLOCK_SIZE = 40
const BLOCK_SPACE = 7

var active_blocks: Array[PieceBlock]
var is_dragging: bool = false
var original_position: Vector2
var is_placed: bool

func _ready() -> void:
	for s in shape:
		var new_block = PIECE_BLOCK.instantiate()
		block_container.add_child(new_block)
		new_block.position = Vector2(s.x * BLOCK_SIZE + s.x * BLOCK_SPACE,\
									 -s.y * BLOCK_SIZE - s.y * BLOCK_SPACE)
		
		active_blocks.append(new_block)
		
	icon_container.size = Vector2(width * BLOCK_SIZE + (width - 1) * BLOCK_SPACE,\
								  height * BLOCK_SIZE + (height - 1) * BLOCK_SPACE)

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not BattleManager.is_enemy_turn:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and BattleManager.action_point > 0:
			is_dragging = true
			original_position = global_position
			for block in active_blocks:
				if block.hovered_tile:
					block.hovered_tile.change_state(Tile.STATE.EMPTY)
			
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_dragging:
			is_dragging = false
			if can_place():
				for block in active_blocks:
					block.hovered_tile.change_state(Tile.STATE.TAKEN)
					block.hovered_tile.reset_color()
				snap_to(active_blocks[0].hovered_tile)
				if (not is_placed):
					BattleManager.add_item_piece(self)
					is_placed = true
					BattleManager.change_action_point(-1)
					BattleManager.item_spawner.new_turn()
			else:
				global_position = original_position
				
func _on_mouse_entered() -> void:
	block_container.visible = false
	
func _on_mouse_exited() -> void:
	block_container.visible = false
	
func can_place() -> bool:
	for block: PieceBlock in active_blocks:
		if not block.is_hovering:
			return false
	return true
	
func snap_to(tile: Tile):
	var pos = Vector2(tile.global_position.x + width * BLOCK_SIZE / 2,\
					  tile.global_position.y + height * BLOCK_SIZE / 2)
	global_position = pos
		
#func _get_drag_data(at_position: Vector2) -> Variant:
	#print("dragging")
	#var preview_texture = ColorRect.new()
	#preview_texture.color = Color.WHITE
	##preview_texture.expand_mode = SIZE_EXPAND
	#preview_texture.size = Vector2(30,30)
	#set_drag_preview(preview_texture)
	#return grid
	#
#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#return true
	#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#pass

