class_name HealthComponent
extends Node

@export var max_hp: float
@export var initial_shield: float
@export var health_bar: ProgressBar
@export var health_display: Label
@export var shield_display: Label
@export var shield_icon: Sprite2D

signal damage_taken()
signal health_depleted()

var hp: float
		
var shield: float:
	set(value):
		shield = value
		shield_icon.visible = true if shield > 0 else false
		shield_display.text = str(shield)

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
			health_depleted.emit()
		health_bar.value = hp / max_hp
	health_display.text = "%s/%s" % [hp, max_hp]
	
func increase_health(value: float) -> void:
	hp += value
	if hp >= max_hp:
		hp = max_hp
	health_bar.value = hp / max_hp
	health_display.text = "%s/%s" % [hp, max_hp]
	
func decrease_armor(value: float) -> void:
	shield -= value
	if shield <= 0:
		shield = 0
	
func increase_armor(value: float) -> void:
	shield += value
