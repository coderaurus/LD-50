extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hide_reload():
	$"Reload Panel".hide()


func show_reload(level_clear, score, next_level = false):
	var msg = ""
	if level_clear:
		msg = "Level cleared!\nScore: %s" % score
	else:
		msg = "Defeat...\nScore: %s" % score
	
	$"Reload Panel/Label".text = msg
	$"Reload Panel".show()
	if next_level:
		$"Reload Panel/NextLevel".show()
		$"Reload Panel/NextLevel".grab_focus()
	else:
		$"Reload Panel/NextLevel".hide()
		$"Reload Panel/Reload".grab_focus()
