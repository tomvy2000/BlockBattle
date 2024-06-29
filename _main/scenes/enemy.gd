class_name Enemy
extends Area2D

@export var health_component: HealthComponent

@export_category("Display")
@export var attack_action_icon: CompressedTexture2D
@export var shield_action_icon: CompressedTexture2D
@export var heal_action_icon: CompressedTexture2D
@export var action_label: Label
@export var icon: TextureRect
@export var indicator: Sprite2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


signal receive_damage()
signal dead(enemy: Enemy)

var attack_damage: float = 10
var heal_amount: float = 5
var shield_up_amount: float = 5

var next_action: String


func _ready() -> void:
	receive_damage.connect(func(): state_machine.travel("hit"))
	health_component.health_depleted.connect(die)
	
	new_turn()

func play_turn(target: Player) -> void:
	await get_tree().create_timer(1).timeout
	
	match next_action:
		"attack":
			attack(target, attack_damage)
		"heal":
			heal(heal_amount)
		"shield_up":
			shield_up(shield_up_amount)
			
func new_turn() -> void:
	set_next_action()
			
func set_next_action() -> void:
	var actions = ["attack", "attack", "attack", "heal", "shield_up"]
	actions.shuffle()
	next_action = actions.pick_random()
	match next_action:
		"attack":
			display_next_action(attack_action_icon, attack_damage)
			action_label.modulate = Color.RED
		"heal":
			display_next_action(heal_action_icon, heal_amount)
			action_label.modulate = Color.GREEN
		"shield_up":
			display_next_action(shield_action_icon, shield_up_amount)
			action_label.modulate = Color.BLUE
			
func display_next_action(tex: CompressedTexture2D, value: float) -> void:
	icon.texture = tex
	action_label.text = str(value)
	
func attack(target: Player, damage: float) -> void:
	state_machine.travel("attack")
	target.health_component.decrease_health(damage)
	
	if damage > 0:
		target.receive_damage.emit()

func heal(amount: float) -> void:
	health_component.increase_health(amount)
	print("enemy heal")
	
func shield_up(amount: float) -> void:
	health_component.increase_armor(amount)
	print("enemy shield up")
	
func die() -> void:
	dead.emit(self)
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			BattleManager.current_enemy = self
