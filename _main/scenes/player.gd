class_name Player
extends Area2D

@export var health_component: HealthComponent

signal action_completed()

func _ready() -> void:
	var action = AttackAction.new(8)
	print(action.attack)
	
func attack(enemy: Enemy, damage: float) -> void:
	enemy.health_component.decrease_health(damage)
	
func heal(amount: float) -> void:
	health_component.increase_health(amount)
	
func shield_up(amount: float) -> void:
	health_component.increase_armor(amount)
