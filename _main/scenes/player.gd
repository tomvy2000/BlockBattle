class_name Player
extends Area2D

@export var health_component: HealthComponent

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

signal action_completed()

func _ready() -> void:
	pass
	
func attack(enemy: Enemy, damage: float) -> void:
	state_machine.travel("attack")
	enemy.health_component.decrease_health(damage)
	
func heal(amount: float) -> void:
	health_component.increase_health(amount)
	
func shield_up(amount: float) -> void:
	health_component.increase_armor(amount)
