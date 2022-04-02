extends Node2D

signal heal
signal hit

export var max_hp = 2
var current_hp = 0
var alive : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp

func _on_Health_hit():
	current_hp -= 1
#	print("%s has %s hp" % [get_parent().name, current_hp])
	if current_hp == 0:
		alive = false
		get_parent().emit_signal("dead")

func alive():
#	print("%s alive: %s" % [get_parent().name, alive])
	return alive

func _on_Health_heal():
	current_hp = clamp(current_hp +1, 0, max_hp)
