class_name ItemSpawner
extends Node

@export var item_pool: Array[PackedScene] = []
@export var item_container: Control

@export var item_pos: Array[Vector2i]

#func _ready() -> void:
	#spawn_items()

func spawn_items() -> void:
	if item_pool.size() <= 0:
		push_error("Item pool is empty")
		return

	for i in 3:
		var item_scene = item_pool.pick_random()
		var item: ItemPiece = item_scene.instantiate()
		item_container.add_child(item)
		item.position = item_pos[i]
		
func clear_items() -> void:
	for item in item_container.get_children():
		if item is ItemPiece:
			if not item.is_placed:
				item.queue_free()
				
func new_turn() -> void:
	for item: ItemPiece in item_container.get_children():
		if not item.is_placed:
			item.queue_free()
	spawn_items()
