extends Node2D

signal heal
signal hit

export var max_hp = 2
var current_hp = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp

func _on_Health_hit():
	current_hp -= 1
	
	if current_hp == 0:
		get_parent().emit_signal("dead")


func _on_Health_heal():
	current_hp = clamp(current_hp +1, 0, max_hp)
