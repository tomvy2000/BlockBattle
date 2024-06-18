extends PanelContainer

@export var grid: Array[int] = []
@export var texture: Texture

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

var active_blocks: Array[PieceBlock]
var is_dragging: bool = false
var original_position: Vector2

func _ready() -> void:
	var blocks = grid_container.find_children("", "PieceBlock", false)
	assert(blocks.size() == grid.size())
	var count = 0
	for i in grid:
		if i == 0:
			blocks[count].color.a = 0
			blocks[count].area_2d.queue_free()
			#blocks[count].area_2d.monitoring = false
		else:
			active_blocks.append(blocks[count])
		count += 1
		
func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = true
			original_position = global_position
			for block in active_blocks:
				if block.hovered_tile:
					block.hovered_tile.change_state(Tile.STATE.EMPTY)
				
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			if can_place():
				for block in active_blocks:
					block.hovered_tile.change_state(Tile.STATE.TAKEN)
					block.hovered_tile.reset_color()
				snap_to(active_blocks[0].hovered_tile.global_position)
			else:
				global_position = original_position
	
func can_place() -> bool:
	for block: PieceBlock in active_blocks:
		if not block.is_hovering:
			return false
	return true
	
func snap_to(pos: Vector2):
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

