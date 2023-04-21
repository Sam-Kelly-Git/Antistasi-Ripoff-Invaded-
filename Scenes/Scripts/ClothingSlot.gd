extends Node2D

@export var h_slots = 6
@export var v_slots = 6
@export var clothing_item = "Clothing"
@export var clothing_slot = "Outift"
@onready var grid = $TextureRect
@onready var slots_collider = $InventorySlots/CollisionShape2D
@onready var slots = $Slots
@onready var label = $Label

var max_slots = h_slots * v_slots
var used_slots = 0

func _ready():
	grid.size.x = 64 * h_slots
	grid.size.y = 64 * v_slots
	
	max_slots = h_slots * v_slots
	
	slots_collider.shape.size.x = 64 * h_slots
	slots_collider.shape.size.y = 64 * v_slots
	slots_collider.position.x = 32 * h_slots
	slots_collider.position.y = 32 * v_slots

@warning_ignore("unused_parameter")
func _process(delta):
	label.text = clothing_slot
	slots.text = clothing_item + " (" + str(used_slots) + "/" + str(max_slots) + ")"
