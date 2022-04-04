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
	#	print("Phylac down | children: %s " % get_child_count())

	# -1 for the phylac node which hasn't been freed yet
	if get_child_count() - 1 == 0:
		var p = get_parent().player
		if p != null:
			p.vulnerable = true
