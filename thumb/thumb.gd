class_name Thumb extends Node2D

var press_time := .0
var press_wait := .3
var last_pos = null
var press_pos_delta = 5.

var pressing: Node2D = null
var holding: Node2D = null

func _process(delta: float) -> void:

	position = get_global_mouse_position()

	if Input.is_action_just_pressed('lmb'):
		pressing = get_hovered()
		last_pos = position

	if Input.is_action_pressed('lmb'):
		if pressing:
			process_interact(delta)

	if Input.is_action_just_released('lmb'):
		if holding:
			print("dropping: ", holding)
			holding = holding.handler.stop_interact()
		pressing = null
		press_time = 0


	if Input.is_action_just_released('rmb'):
		var item = holding if holding else get_hovered()
		if item:
			item.handler.action()

	if Input.is_action_just_released('flip'):
		print("flip: ", pressing)
		var item = holding if holding else get_hovered()
		if item:
			item.handler.flip()


func get_hovered() -> ItemBody:
	var overlaps = $Area2D.get_overlapping_bodies()
	print("overlaps: ", overlaps)
	if not overlaps.is_empty() and overlaps[0] is ItemBody:
		return overlaps[0]
	return null

func process_interact(delta: float):
	if (last_pos - position).length() > press_pos_delta \
	or not pressing.handler.has_method("long_interact"):
		holding = pressing.handler.interact(self)
	elif press_time > press_wait:
		holding = pressing.handler.long_interact(self)
	else:
		press_time += delta
		last_pos = position 
		return

	pressing = null
	press_time = .0
