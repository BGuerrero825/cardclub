extends Node2D

var card_scene = preload("res://items/card/card.tscn")
var stack_scene = preload("res://items/stack/stack.tscn")
var world

func _ready():
	world = self.get_parent()
	Global.spawner = self
	Global.world = world

func spawn_card():
	pass

func spawn_stack() -> ItemBody:
	var stack = stack_scene.instantiate()
	stack.global_position = self.global_position
	world.add_child(stack)
	return stack


