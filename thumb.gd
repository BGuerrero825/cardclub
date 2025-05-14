extends Node2D

var holding: Node2D = null 

func _process(_delta: float) -> void:
	self.position = get_global_mouse_position()
	if Input.is_action_just_pressed('lmb'):
		var overlaps = $Area2D.get_overlapping_bodies()
		print("overlaps: ", overlaps)
		if not overlaps.is_empty() and "holder" in overlaps[0]:
			var item = overlaps[0]
			holding = item
			item.pickup(self)

	if Input.is_action_just_released('lmb') and holding:
		print("holding: ", holding)
		holding.drop()
		holding = null

	if Input.is_action_just_released('flip') and holding:
		print("flip: ", holding)
		holding.flip()
