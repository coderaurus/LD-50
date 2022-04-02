extends KinematicBody2D

signal hit
signal dead


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_hit():
	$Health.emit_signal("hit")


func _on_dead():
	queue_free()
