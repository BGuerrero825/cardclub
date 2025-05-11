extends Node2D

var held: Node2D = null 

func _process(_delta: float) -> void:
	self.position = get_global_mouse_position()
	if Input.is_action_just_pressed('lmb'):
		var overlaps = $Area2D.get_overlapping_bodies()
		print("overlaps: ", overlaps)
		if not overlaps.is_empty():
			var item = overlaps[0]
			held = item
			item.pickup(self)

	if Input.is_action_just_released('lmb') and held:
		print("held: ", held)
		held.drop()
		held = null
