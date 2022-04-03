extends Node2D

signal phylac_down
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_phylac_down():
	if get_child_count() == 0:
		var p = get_parent().get_node_or_null("Player")
		if p != null:
			p.vulnerable = true
