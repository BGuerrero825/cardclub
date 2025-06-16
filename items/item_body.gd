class_name ItemBody extends CharacterBody2D 

const vz = Vector2.ZERO 
const TABLE_Z = 0
const HAND_Z = 10
const POINTER_Z = 20

@export var itemcom: ItemComponent = null # Item Component 
@export var cardcom: CardComponent = null # Card Component 
@export var stackcom: StackComponent = null # Stack Component 

@export var magnetism := 15.0
@export var friction := .15
@export var snap_distance := 1.5 

var pointer: Pointer = null
var tether: Node2D = null
var hand_pos = null

signal grabbed_by(item, pointer)
signal reached_target(item, target_pos)

@onready var debug: DebugLabel = $Debug # Debug print tool 


func _ready() -> void:
	assert(itemcom != null, "No 'itemcom' node assigned as an item component!")


func _physics_process(_delta: float) -> void:
	var target_pos = null
	if pointer:
		z_index = POINTER_Z
		target_pos = pointer.global_position
	elif tether:
		z_index = HAND_Z
		if hand_pos:
			target_pos = hand_pos
		else:
			target_pos = tether.global_position
	else: 
		z_index = TABLE_Z
	
	_move_item(target_pos)
	debug.display("target_pos", target_pos)
	debug.display("velocity", self.velocity)


# EXTERNALS #

func init_interact(_pointer: Pointer) -> ItemBody:
	if cardcom:
		return interact(_pointer)
	return null

func interact(_pointer: Pointer) -> ItemBody:
	if cardcom:
		itemcom.lift()
		set_pointer(_pointer)
		move_to_front()
		return self
	elif stackcom:
		return stackcom.draw_card(_pointer)
	return null

func long_interact(_pointer: Pointer) -> ItemBody:
	if cardcom:
		var stack = cardcom.try_stacking()
		if stack:
			return stack.long_interact(_pointer)
		else:
			return interact(_pointer)
	elif stackcom:
		itemcom.lift()
		stackcom.lift()
		set_pointer(_pointer)
		move_to_front()
		return self
	return null
		
func stop_interact() -> ItemBody:
	itemcom.drop()
	set_pointer(null)
	if cardcom:
		cardcom.drop()
	elif stackcom:
		stackcom.drop()
	return null

func action():
	if cardcom:
		flip()
	elif stackcom:
		stackcom.shuffle()
		if not pointer:
			itemcom.jump()
	pass

func flip():
	if cardcom:
		if not pointer and not tether:
			itemcom.jump()
		cardcom.flip()

func stack_items() -> ItemBody:
	if cardcom:
		print("were stacking whoa")
		return cardcom.try_stacking()
	return null

func enter_hand(new_hand: Hand) -> ItemBody:
	if cardcom:
		velocity = vz
		tether = new_hand
		itemcom.lift()
		if !cardcom.up:
			cardcom.flip()
		return self 
	return null

func to_stack(stack_up: bool):
	if cardcom:
		if stack_up != cardcom.up:
			cardcom.flip()

func set_tether(new_tether: Area2D):
	tether = new_tether
	move_to_front()

func set_hand_pos(new_hand, new_hand_pos):
	tether = new_hand 
	hand_pos = new_hand_pos
	move_to_front()

func is_flipped(up: bool):
	if cardcom:
		if cardcom.up == up and cardcom.flip_dir == 0:
			return true
	return false

func set_pointer(new_pointer: Pointer):
	pointer = new_pointer
	if pointer != null:
		grabbed_by.emit(self, pointer)


# INTERNALS #

func _move_item(target_pos):
	if target_pos:
		velocity = lerp(vz, target_pos - self.global_position, magnetism)
		move_and_slide()
		if (self.global_position - target_pos).length() < snap_distance:
			self.global_position = target_pos
			reached_target.emit(self, target_pos)
	else:
		velocity = lerp(velocity, vz, friction)
		if velocity.length() < 1:
			velocity = vz
		move_and_slide()


