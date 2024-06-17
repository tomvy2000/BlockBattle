class_name PieceBlock
extends ColorRect

@onready var area_2d: Area2D = $Area2D

var is_hovering: bool
var active_tile: Tile

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)
		
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().tile_state == area.get_parent().STATE.EMPTY:
		is_hovering = true
		active_tile = area.get_parent()
	
func _on_area_exited(area: Area2D) -> void:
	#if area.tile_state == area.STATE.EMPTY:
	is_hovering = false
	
	
