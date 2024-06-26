class_name PieceBlock
extends Area2D


var is_hovering: bool
var hovered_tile: Tile

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
		
	
func _on_area_entered(area: Area2D) -> void:
	#if area.get_parent().tile_state == area.get_parent().STATE.EMPTY:
		#is_hovering = true
		#hovered_tile = area.get_parent()
	pass
	
func _on_area_exited(_area: Area2D) -> void:
	#if area.tile_state == area.STATE.EMPTY:
	is_hovering = false
	
	
