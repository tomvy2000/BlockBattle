class_name Tile
extends Area2D

enum STATE {EMPTY, HOVER, TAKEN}
enum TYPE {ATTACK, DEFEND, HEAL, EVADE}
var tile_state = STATE.EMPTY
var tile_type = TYPE.ATTACK
var color: Color

@onready var color_sprite: Sprite2D = $Color

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
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
			color_sprite.modulate = Color.RED
		TYPE.DEFEND:
			color_sprite.modulate = Color.BLUE
		TYPE.HEAL:
			color_sprite.modulate = Color.GREEN
		TYPE.EVADE	:
			color_sprite.modulate = Color.YELLOW
	color = color_sprite.modulate
	
func reset_color() -> void:
	color_sprite.color = color
			
func _on_area_entered(area: Area2D) -> void:
	if tile_state == STATE.EMPTY:
		color_sprite.modulate = Color.REBECCA_PURPLE
	
func _on_area_exited(area: Area2D) -> void:
	if tile_state == STATE.EMPTY:
		color_sprite.modulate = color
