extends Node2D

@export var h_slots = 6
@export var v_slots = 4

@onready var grid = $TextureRect
@onready var slots_collider = $InventorySlots/CollisionShape2D

func _ready():
	grid.size.x = 64 * h_slots
	grid.size.y = 64 * v_slots
	
	slots_collider.shape.size.x = 64 * h_slots
	slots_collider.shape.size.y = 64 * v_slots
	slots_collider.position.x = 32 * h_slots
	slots_collider.position.y = 32 * v_slots
