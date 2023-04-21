extends Node2D

var mouseInside = false
var itemInside = false
var insideItem = false
var selected = false
var target_body
var quad_amount : int = 0
@export var return_position : Vector2
@export var h_size : int = 1
@export var v_size : int = 1
var target_position : Vector2

@onready var texture = $TextureRect
@onready var mouse_collision = $ItemCollision/CollisionShape2D

func _ready():
	target_position = global_position
	return_position = global_position

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if Input.is_action_just_pressed("Left_Click") and mouseInside:
		selected = true
		return_position = global_position
	
#	global_position = lerp(global_position, target_position, 0.85)
	
	texture.size.x = 64 * h_size
	texture.size.y = 64 * v_size
	
#	mouse_collision.shape.size.x = 48 * h_size
#	mouse_collision.position.x 
#	$TL.position = Vector2(-16 * h_size, -16 * v_size)
#	$TR.position = Vector2(16 * h_size, -16 * v_size)
#	$BR.position = Vector2(16 * h_size, 16 * v_size)
#	$BL.position = Vector2(-16 * h_size, 16 * v_size)
	
	if quad_amount == 4 and not insideItem:
		itemInside = true
	elif quad_amount <= 3 or insideItem:
		itemInside = false
	
	
	if selected and Input.is_action_pressed("Left_Click"):
		global_position = get_global_mouse_position()
		top_level = true
	if selected and Input.is_action_just_released("Left_Click"):
		if itemInside:
			var new_parent = target_body
			get_parent().remove_child(self)
			new_parent.add_child(self)
			position = position.snapped(Vector2(64, 64))
		else:
			global_position = return_position
		selected = false

func _on_tl_area_entered(area):
	if area.is_in_group("InventorySlot"):
		quad_amount += 1
		target_body = area.get_parent()

func _on_tr_area_entered(area):
	if area.is_in_group("InventorySlot"):
		quad_amount += 1
		target_body = area.get_parent()

func _on_bl_area_entered(area):
	if area.is_in_group("InventorySlot"):
		quad_amount += 1
		target_body = area.get_parent()

func _on_br_area_entered(area):
	if area.is_in_group("InventorySlot"):
		quad_amount += 1
		target_body = area.get_parent()

func _on_tl_area_exited(area):
	if area.is_in_group("InventorySlot"):
		quad_amount -= 1
		target_body = null

func _on_tr_area_exited(area):
	if area.is_in_group("InventorySlot"):
		quad_amount -= 1
		target_body = null

func _on_bl_area_exited(area):
	if area.is_in_group("InventorySlot"):
		quad_amount -= 1
		target_body = null

func _on_br_area_exited(area):
	if area.is_in_group("InventorySlot"):
		quad_amount -= 1
		target_body = null

func _on_mouseinput_mouse_entered():
	mouseInside = true

func _on_mouseinput_mouse_exited():
	mouseInside = false

func _on_item_collision_area_entered(area):
	if area.is_in_group("Item"):
		insideItem = true

func _on_item_collision_area_exited(area):
	if area.is_in_group("Item"):
		insideItem = false
		print(2)
