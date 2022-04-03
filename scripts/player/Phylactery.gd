extends KinematicBody2D

signal hit
signal dead


func _on_hit():
	$Health.emit_signal("hit")


func _on_dead():
	get_parent().emit_signal("phylac_down")
	queue_free()
