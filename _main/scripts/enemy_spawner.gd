class_name EnemySpawner
extends Node

@export var enemy_pool: Array[EnemyPoolData]
@export var spawn_position: Array[Marker2D]
@export var enemies: Array[EnemySpawnPlanData]

const SPACING: int = 10
var viewport_size: Vector2

func _ready() -> void:
	pass
	
func spawn(room: int) -> void:
	var count = 0
	for i in enemies[room].enemies:
		spawn_enemy(i, spawn_position[count].position)
		count += 1
	
func spawn_enemy(id: int, position: Vector2) -> void:
	var enemy = enemy_pool[id].scene.instantiate()
	add_child(enemy)
	enemy.position = position
	BattleManager.add_enemy(enemy)
	
