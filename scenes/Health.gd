extends Node2D

signal heal
signal hit

export var max_hp = 2
export var current_hp = 0
var alive : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if current_hp == 0:
		current_hp = max_hp
	$Health2.text = str(current_hp)
	$AnimationPlayer.play("Hide")

func _on_Health_hit():
#	print("%s got hit" % get_parent().name)
	current_hp -= 1
	$Health2.text = str(current_hp)
	
	$AnimationPlayer.play("Pop")
	
#	print("%s has %s hp" % [get_parent().name, current_hp])
	if current_hp == 0:
		alive = false
		get_parent().emit_signal("dead")


func show_health():
	$Health2.text = "%s/%s" % [current_hp, max_hp]
	$AnimationPlayer.play("Show")

func health_missing():
	var missing = max_hp - current_hp
#	print("%s - %s = %s" % [max_hp, current_hp, missing])
	return missing


func alive():
#	print("%s alive: %s" % [get_parent().name, alive])
	return alive

func _on_Health_heal(amount = 1):
	current_hp = clamp(current_hp + amount, 0, max_hp)
	$Health2.text = "+"+str(amount)
	$AnimationPlayer.play("Pop")
#	print("Healed %s" % amount)
