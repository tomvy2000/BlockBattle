class_name ItemData
extends Resource

enum ItemType {WEAPON, ARMOR, HEAL, SKILL}

@export var name: String
@export var attack: float
@export var shield: float
@export var heal: float
@export var evade: int
@export var type: ItemType



