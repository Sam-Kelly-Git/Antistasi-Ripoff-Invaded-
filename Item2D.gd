extends Node2D

var mouseInside = false
var itemInside = false
var insideItem = false
var selected = false
var target_body
var quad_amount : int = 0
@export var return_position : Vector2
@export var h_size : int = 2
@export var v_size : int = 2
var target_position : Vector2

@onready var texture = $TextureRect

func _ready():
	target_position = global_position
	return_position = global_position

func _physics_process(delta):
	if Input.is_action_just_pressed("Left_Click") and mouseInside:
		selected = true
		return_position = global_position
	
	global_position = lerp(global_position, target_position, 0.85)
	
	texture.size.x = 64 * h_size
	texture.size.y = 64 * v_size
	texture.position.x = 32 * h_size - 128
	texture.position.y = 32 * v_size - 128
	
	$TL.position = Vector2(-16 * h_size, -16 * v_size)
	$TR.position = Vector2(16 * h_size, -16 * v_size)
	$BR.position = Vector2(16 * h_size, 16 * v_size)
	$BL.position = Vector2(-16 * h_size, 16 * v_size)
	
	if quad_amount == 4 and not insideItem:
		itemInside = true
#		print(str(name) + " inside")
	elif quad_amount <= 3 or insideItem:
		itemInside = false
#		print(str(name) + " not inside")
	
	
	if selected and Input.is_action_pressed("Left_Click"):
		target_position = get_global_mouse_position()
		top_level = true
		if Input.is_action_just_pressed("Rotate") and rotation_degrees == 0:
			rotation_degrees = 90
		elif Input.is_action_just_pressed("Rotate") and rotation_degrees == 90:
			rotation_degrees = 0
	elif Input.is_action_just_released("Left_Click") and selected:
		if itemInside:
			target_position = global_position.snapped(Vector2(64, 64))
#			var new_parent = target_body
#			get_parent().remove_child(self)
#			new_parent.add_child(self)
		else:
			target_position = return_position
		selected = false
		top_level = false


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

func _on_mouseinput_area_entered(area):
	if area.is_in_group("Item"):
		insideItem = true

func _on_mouseinput_area_exited(area):
	if area.is_in_group("Item"):
		insideItem = false
