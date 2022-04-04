extends Navigation2D

signal enemy_down

export var wave_info : Dictionary = {}
var waves = 0
var wave = 0
var enemy_wave_left = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	wave = 0
	waves = 0
	waves = wave_info.size()


func get_simple_path_global(start_global: Vector2, end_global: Vector2, optimize: bool = true) -> PoolVector2Array:
	var path: PoolVector2Array = get_simple_path(to_local(start_global), to_local(end_global), optimize)
	for i in range(path.size()):
		path[i] = to_global(path[i])
	return path


func start_map():
	show_current_healths()
	$NewWaveTimer.start()


func _on_enemy_down():
	enemy_wave_left -= 1
	get_tree().current_scene.add_score(50)
#	print("Enemies left ", enemy_wave_left)
	if enemy_wave_left == 0:
		_wave_clear()
		

func _wave_clear():
#	print("Wave clear")
	if wave < waves:
		show_current_healths()
		$NewWaveTimer.start()
	else:
		get_tree().current_scene.level_clear()


func show_current_healths():
	var world = get_parent().get_parent()
	for phyla in world.get_node("Phylacteries").get_children():
		phyla.show_health()
	world.player.show_health()


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
	
#	print("Split rules ", rules)
	wave += 1
	for i in range($SpawnPoints.get_child_count()):
		if rules.size() > i:
			$SpawnPoints.get_child(i).populate(rules[i])
	get_tree().current_scene.show_waves(wave, waves)
	
