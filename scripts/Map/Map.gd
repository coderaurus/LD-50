extends Navigation2D

signal enemy_down

export var wave_info : Dictionary = {}
var waves = 0
var wave = 0
var enemy_wave_left = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	$NewWaveTimer.start()
	waves = wave_info.size()


func _on_enemy_down():
	enemy_wave_left -= 1
	get_tree().current_scene.add_score(50)
#	print("Enemies left ", enemy_wave_left)
	if enemy_wave_left == 0:
		_wave_clear()
		

func _wave_clear():
#	print("Wave clear")
	if wave < waves:
		$NewWaveTimer.start()
	else:
		get_tree().current_scene.level_clear()


func _on_new_wave():
	var next_wave = wave_info.get(wave)
	enemy_wave_left = 0
	
	var rules =  next_wave
	# Calculate spwan amounts for wave
	for rule in rules:
		rule  = rule.split(";")
#		print("Rules split ", rule)
		for part in rule:
			part = part.split(" ")
			enemy_wave_left += int(part[0])
	
	print("Split rules ", rules)
	wave += 1
	for i in $SpawnPoints.get_child_count():
		$SpawnPoints.get_child(i).populate(rules[i])
