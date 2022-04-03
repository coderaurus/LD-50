extends KinematicBody2D

signal hit
signal dead


func _process(delta):
	if $Health.health_missing() == 0 and !$HealTooltip.visible:
		$AnimationPlayer.advance(0)
		$AnimationPlayer.play("Hide Heal Tip")


func show_health():
	$Health.show_health()


func _on_hit():
	$Health.emit_signal("hit")
	get_tree().current_scene.get_node("SoundPlayer").sound("phylactery_hit")


func _on_dead():
	get_tree().current_scene.get_node("SoundPlayer").sound("phylactery_death")
	get_parent().emit_signal("phylac_down")
	queue_free()
