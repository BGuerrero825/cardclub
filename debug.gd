class_name DebugLabel extends Label

@export var remove_after := 300 # frames

var vardict: Dictionary = {}
var usedict: Dictionary = {}

func _process(_delta: float) -> void:
	self.text = ""
	if !Global.debugging:
		return
	for key in vardict:
		self.text += "%s : %s\n" % [key, str(vardict[key])]
		usedict[key] += 1
		if usedict[key] > remove_after:
			usedict.erase(key)
			vardict.erase(key)

func display(key: String, value: Variant):
	vardict[key] = value
	usedict[key] = 0
