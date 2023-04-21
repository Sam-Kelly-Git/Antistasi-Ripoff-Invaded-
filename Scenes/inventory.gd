extends Control


@onready var slots = $Slots

func _on_v_scroll_bar_scrolling():
	slots.position.y = $VScrollBar.value
