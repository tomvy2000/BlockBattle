class_name Board
extends PanelContainer

@export var width: int = 5
@export var height: int = 5

@onready var board_grid: GridContainer = $MarginContainer/BoardGrid

signal board_filled()

const TILE = preload("res://_main/scenes/tile.tscn")

var tiles = []
var matrix = []

func _ready() -> void:
	create_colored_matrix(height, width)
	board_grid.columns = width
	for i in range(width * height):
		var tile_scene: Tile = TILE.instantiate()
		board_grid.add_child(tile_scene)
		match matrix[i]:
			"red":
				tile_scene.set_type(0)
			"green":
				tile_scene.set_type(1)
			"blue":
				tile_scene.set_type(2)
			"yellow":
				tile_scene.set_type(3)
				
		#tile_scene.set_type(randi_range(0, 3))
	tiles = board_grid.get_children()
	#set_corner_color()

func refill_board() -> void:
	create_colored_matrix(height, width)
	for i in range(width * height):
		tiles[i].change_state(Tile.STATE.EMPTY)
		match matrix[i]:
			"red":
				tiles[i].set_type(0)
			"green":
				tiles[i].set_type(1)
			"blue":
				tiles[i].set_type(2)
			"yellow":
				tiles[i].set_type(3)
	board_filled.emit()
	
func set_corner_color() -> void:
	tiles[0].set_type(Tile.TYPE.ATTACK) #upper-left corner
	tiles[-1].set_type(Tile.TYPE.EVADE) #lower-right corner
	tiles[width - 1].set_type(Tile.TYPE.HEAL) #upper-right corner
	tiles[width * height - width].set_type(Tile.TYPE.DEFEND) #lower-left corner
	
func create_colored_matrix(rows: int, cols: int) -> Array:
	# Initialize the matrix as a 1D array with empty values
	matrix.clear()
	for i in range(rows * cols):
		matrix.append('')
	
	# Define corner colors
	var corner_colors = {
		0: 'red',                      # upper-left
		cols - 1: 'green',             # upper-right
		(rows - 1) * cols: 'blue',     # lower-left
		rows * cols - 1: 'yellow'      # lower-right
	}
	
	# Assign corner colors
	for index in corner_colors:
		matrix[index] = corner_colors[index]
	
	# Calculate the maximum area for each region to ensure even distribution
	var total_cells = rows * cols
	#var color_limits = total_cells / 4
	
	# Spread colors from the corners with a limited area
	var colored = 0
	for index in corner_colors:
		var color_limits = randi_range(3, 8)
		if index == rows * cols - 1:
			color_limits = rows * cols - colored
		colored += color_limits
		flood_fill(index, corner_colors[index], color_limits)
	
	# Fill remaining slots randomly with available colors
	var remaining_colors = ['red', 'green', 'blue', 'yellow']
	for i in range(rows * cols):
		if matrix[i] == '':
			matrix[i] = remaining_colors[randi() % remaining_colors.size()]
	
	return matrix

# Flood fill function to spread the color within a limited area
func flood_fill(index: int, color: String, limit: int) -> void:
	var stack = [index]
	var visited = sett(stack)
	var area = 0
	while stack.size() > 0 and area < limit:
		var current = stack.pop_back()
		for neighbor in get_neighbors(current):
			if matrix[neighbor] == '' and neighbor not in visited:
				matrix[neighbor] = color
				stack.append(neighbor)
				visited.append(neighbor)
				area += 1
				if area >= limit:
					break
	
# Helper function to get neighboring cells in the 1D array
func get_neighbors(index: int) -> Array:
	var neighbors = []
	var r = index / width
	var c = index % width
	if r > 0:
		neighbors.append(index - width)       # Up
	if r < height - 1:
		neighbors.append(index + width)       # Down
	if c > 0:
		neighbors.append(index - 1)          # Left
	if c < width - 1:
		neighbors.append(index + 1)          # Right
	return neighbors

func print_matrix(matrix: Array, rows: int, cols: int) -> void:
	for r in range(rows):
		var row = []
		for c in range(cols):
			row.append(matrix[r * cols + c])
		print(row)

func sett(arr):
	var hash = {}
	for element in arr:
		hash[element] = true
	return hash.keys()
