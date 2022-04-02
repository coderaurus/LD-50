extends Navigation2D

signal enemy_down

export var wave_info : Dictionary = {}
var wave = 0
var enemy_wave_left = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$NewWaveTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_enemy_down():
	enemy_wave_left -= 1
	print("Enemies left ", enemy_wave_left)
	if enemy_wave_left == 0:
		print("Wave clear")
		$NewWaveTimer.start()


func _on_new_wave():
	var next_wave = wave_info.get(wave)
	enemy_wave_left = 0
	
	var rules =  next_wave
	# Calculate spwan amounts for wave
	for rule in rules:
		rule  = rule.split(";")
		print("Rules split ", rule)
		for part in rule:
			part = part.split(" ")
			enemy_wave_left += int(part[0])
	
	print("Split rules ", rules)
	wave += 1
	for i in $SpawnPoints.get_child_count():
		$SpawnPoints.get_child(i).populate(rules[i])
