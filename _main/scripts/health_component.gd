class_name HealthComponent
extends Node

@export var max_hp: float
@export var initial_shield: float
@export var health_bar: ProgressBar
@export var health_display: Label
@export var shield_display: Label

signal damage_taken()
signal health_depleted()

var hp: float
var shield: float

func _ready() -> void:
	increase_health(max_hp)
	increase_armor(initial_shield)

func decrease_health(value: float) -> void:
	var unblocked_damage = shield - value
	decrease_armor(value)
	if unblocked_damage < 0:
		hp -= abs(unblocked_damage)
		if hp <= 0:
			hp = 0
		health_bar.value = hp / max_hp
	health_display.text = "%s/%s" % [hp, max_hp]
	
func increase_health(value: float) -> void:
	hp += value
	if hp >= max_hp:
		hp = max_hp
	health_bar.value = hp / max_hp * 100
	health_display.text = "%s/%s" % [hp, max_hp]
	
func decrease_armor(value: float) -> void:
	shield -= value
	if shield <= 0:
		shield = 0
		#armor_display.visible = false
	shield_display.text = str(shield)
		
func increase_armor(value: float) -> void:
	shield += value
	#if armor > 0:
		#armor_display.visible = true
	shield_display.text = str(shield)
