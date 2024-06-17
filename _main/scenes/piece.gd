extends PanelContainer

@export var grid: Array[int] = []

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

var active_blocks: Array[PieceBlock]

func _ready() -> void:
	var blocks = grid_container.find_children("", "PieceBlock", false)
	assert(blocks.size() == grid.size())
	var count = 0
	for i in grid:
		if i == 0:
			blocks[count].color.a = 0
			blocks[count].area_2d.monitorable = false
			blocks[count].area_2d.monitoring = false
		else:
			active_blocks.append(blocks[count])
		count += 1
		
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if can_place():
				for block in active_blocks:
					block.active_tile.change_state(Tile.STATE.TAKEN)
	
func can_place() -> bool:
	for block: PieceBlock in active_blocks:
		if not block.is_hovering:
			return false
	return true
		
func _get_drag_data(at_position: Vector2) -> Variant:
	return grid
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	pass
