class_name Pointer extends Node2D

var press_time := .0
var press_wait := .3
var press_pos = null
var interact_pos_delta = 5.

var pressing: Node2D = null
var holding: ItemBody = null

@onready var debug := $Debug

func _process(delta: float) -> void:

	position = get_global_mouse_position()

	# LMB interactions (click, hold)
	if Input.is_action_just_pressed('lmb'):
		pressing = get_hovered()
		press_pos = position
		if pressing:
			holding = pressing.init_interact(self)
			if holding:
				pressing = null

	if Input.is_action_pressed('lmb'):
		if pressing:
			process_interact(delta)

	if Input.is_action_just_released('lmb'):
		pressing = null
		press_time = 0
		if not holding:
			return
		holding = holding.stop_interact()

	# Other interactions (click only)
	if Input.is_action_just_released('rmb'):
		var item = holding if holding else get_hovered()
		if item:
			item.action()

	if Input.is_action_just_released('flip'):
		var item = holding if holding else get_hovered()
		if item:
			item.flip()

	if Input.is_action_just_released('stack'):
		if holding:
			return
		var item = get_hovered()
		if item:
			item.stack_items()

	# For debug purposes only
	if Input.is_action_just_released("bugger"):
		Global.debugging = !Global.debugging


# INTERNALS #

func get_hovered() -> ItemBody:
	var overlaps = $Area2D.get_overlapping_bodies()
	#debug.display("overlaps", overlaps)
	return get_top_overlap(overlaps)

func process_interact(delta: float):
	if (press_pos - position).length() > interact_pos_delta:
		holding = pressing.interact(self)
	elif press_time > press_wait:
		holding = pressing.long_interact(self)
	else:
		press_time += delta
		press_pos = position 
		return

	pressing = null
	press_time = .0

func get_top_overlap(overlaps: Array):
	if overlaps.is_empty():
		return null
	var top: ItemBody = null
	var top_index = 0
	for item in overlaps:
		if item is ItemBody and item.get_index() >= top_index:
			top = item
			top_index = item.get_index()
	return top
