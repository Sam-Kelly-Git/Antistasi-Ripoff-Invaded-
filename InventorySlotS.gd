extends Area2D

var mouseInside = false

func _on_mouse_entered():
	mouseInside = true

func _on_mouse_exited():
	mouseInside = false

