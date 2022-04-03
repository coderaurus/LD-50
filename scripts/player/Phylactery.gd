extends KinematicBody2D

signal hit
signal dead


func show_health():
	$Health.show_health()


func _on_hit():
	$Health.emit_signal("hit")


func _on_dead():
	get_parent().emit_signal("phylac_down")
	queue_free()
