extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var game_over = false
var level_complete = false
var game_paused = false
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func game_over():
	get_tree().paused = true
	game_over = true
	game_paused = true
	$UI.show_reload(level_complete, score)


func level_clear():
	get_tree().paused = true
	game_over = true
	game_paused = true
	level_complete = true
	$UI.show_reload(level_complete, score)

func add_score(amount):
	score += amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Reload():
	get_tree().reload_current_scene()
	get_tree().paused = false
