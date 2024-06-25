class_name HealthComponent
extends Node

@export var max_hp: int
@export var health_bar: ProgressBar
@export var armor_display: Node2D

signal damage_taken()
signal health_depleted()

var hp: int
var armor: int

func _ready() -> void:
	hp = max_hp
	health_bar.value = hp / max_hp * 100

func decrease_health(value: int) -> void:
	var unblocked_damage = armor - value
	decrease_armor(value)
	if unblocked_damage < 0:
		hp -= value
		if hp <= 0:
			hp = 0
		health_bar.value = hp / max_hp * 100
	
func increase_health(value: int) -> void:
	hp += value
	if hp >= max_hp:
		hp = max_hp
	health_bar.value = hp / max_hp * 100
	
func decrease_armor(value: int) -> void:
	armor -= value
	if armor <= 0:
		armor = 0
		armor_display.visible = false
		
func increase_armor(value: int) -> void:
	armor += value
	if armor > 0:
		armor_display.visible = true
