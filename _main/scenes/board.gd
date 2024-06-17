extends PanelContainer

@export var width: int = 5
@export var height: int = 5

@onready var board_grid: GridContainer = $MarginContainer/BoardGrid
const TILE = preload("res://_main/scenes/tile.tscn")
func _ready() -> void:
	board_grid.columns = width
	for i in range(width * height):
		var tile_scene: Tile = TILE.instantiate()
		board_grid.add_child(tile_scene)
		tile_scene.set_type(randi_range(0, 3))

func init() -> void:
	pass
	
