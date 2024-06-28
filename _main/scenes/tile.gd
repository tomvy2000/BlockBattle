class_name  Tile
extends PanelContainer

enum STATE {EMPTY, HOVER, TAKEN}
enum TYPE {ATTACK, DEFEND, HEAL, EVADE}
var tile_state = STATE.EMPTY
var tile_type = TYPE.ATTACK
var color: Color

@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)
	
func change_state(state: STATE):
	tile_state = state
	#match tile_state:
		#STATE.TAKEN:
			#color_rect.color = Color.RED
		#STATE.EMPTY:
			#color_rect.color = Color.WHITE
		#STATE.HOVER:
			#color_rect.color = Color.REBECCA_PURPLE
			
func set_type(type: TYPE) -> void:
	tile_type = type
	set_color()
			
func set_color() -> void:
	match tile_type:
		TYPE.ATTACK:
			color_rect.color = Color.RED
		TYPE.DEFEND:
			color_rect.color = Color.BLUE
		TYPE.HEAL:
			color_rect.color = Color.GREEN
		TYPE.EVADE	:
			color_rect.color = Color.YELLOW
	color = color_rect.color
	
func reset_color() -> void:
	color_rect.color = color
			
func _on_area_entered(_area: Area2D) -> void:
	if tile_state == STATE.EMPTY:
		color_rect.color = Color.REBECCA_PURPLE
	
func _on_area_exited(_area: Area2D) -> void:
	if tile_state == STATE.EMPTY:
		color_rect.color = color
