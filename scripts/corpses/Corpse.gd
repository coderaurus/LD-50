extends StaticBody2D

signal hit
signal dead


func _on_hit():
	$Health.emit_signal("hit")


func _on_dead():
	queue_free()
