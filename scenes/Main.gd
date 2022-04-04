extends Node2D


var game_started = false
var game_over = false
var level_complete = false
var game_paused = false
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_tree().paused = true
	show_souls($World.player.souls)
	add_score(0)
	yield($MusicPlayer, "tree_entered")
	$MusicPlayer.song("main")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_home"):
		$UI.toggle_menu()


func game_over():
	get_tree().paused = true
	game_over = true
#	game_paused = true
	$UI.show_reload(level_complete, score)


func level_clear():
	get_tree().paused = true
	game_over = true
#	game_paused = true
	level_complete = true
	if $World.current_map < $World.map_paths.size() -1:
		$UI.show_reload(level_complete, score, true)
		$MusicPlayer.song("level_clear")
	else:
		$UI.show_victory(score)
		$MusicPlayer.song("victory")

func add_score(amount):
	score += amount
	$UI/Score.text = "%sp" % score 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func show_souls(amount):
	$UI/Souls.text = "Souls: %s" % amount


func show_waves(current, total):
	$UI/Waves.text = "Wave %s/%s" % [current, total]


func _on_reload():
	$SoundPlayer.sound("click")
	level_complete = false
	$World.reload_map()
	add_score(0)
	score = 0
	$UI.hide_reload()
	get_tree().paused = false


func _on_next_level():
	$SoundPlayer.sound("click")
	$UI.hide_reload()
	level_complete = false
	$World.load_next_map()


func _on_play_again():
	$SoundPlayer.sound("click")
	game_started = false
	level_complete = false
	$World/Player.souls = 0 
	score = 0
	get_tree().reload_current_scene()
