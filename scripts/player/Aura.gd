extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dmg = 1 

var enemies_in_aura : Array = []
var phylactery_in_aura = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Pulse")


func _on_aura_tick():
	for e in enemies_in_aura:
		if e != null:
			e.emit_signal("hit")


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_aura.append(body)
#		body.emit_signal("hit")
	elif body.is_in_group("phylactery"):
#		print("Phylactery in range")
		phylactery_in_aura = body
		if body.get_node("Health").health_missing() > 0:
			body.get_node("AnimationPlayer").play("Show Heal Tip")
		


func _on_body_exited(body):
	if body.is_in_group("enemy"):
		var index = enemies_in_aura.find(body)
		enemies_in_aura.remove(index)
	elif body.is_in_group("phylactery"):
		phylactery_in_aura = null
		if body.get_node("HealTooltip").visible:
			body.get_node("AnimationPlayer").play("Hide Heal Tip")
	
