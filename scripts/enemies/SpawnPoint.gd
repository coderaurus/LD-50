extends Node2D


#export var enemy_list : Dictionary = {} 
onready var enemy = preload("res://scenes/enemies/Enemy.tscn")
onready var world = get_tree().current_scene.get_node("World")
export var inital_index = 0

var spawn_rules = []
var spawns_per_wave = 5
var spawned = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func populate(var rules = []):
	spawns_per_wave = 0
#	print("Received rules ", rules)
	rules = rules.split(";")
	for r in rules:
		var split = r.split(" ")
#		print(" Split ", split)
		for i in range(int(split[0])):
			spawn_rules.append(split[1])
		spawns_per_wave += int(split[0])
		
#	print("[%s] Spawn rules " % self.name, spawn_rules)
#	spawns_per_wave = spawns
	spawned = 0
#	print("[%s] Spawns this wave " % self.name, spawns_per_wave)
	$SpawnTimer.start()

func _on_spawn():
	var e = enemy.instance()
	var split = spawn_rules[spawned].split(" ")
#	print("[%s] Split on spawn (%s spawned)" % [self.name, spawned], split)
	match spawn_rules[spawned][1]:
		"path": # follow the road
			e.on_path = true
			e.followed_path = world.get_node("Map").get_node("Road").get_child(inital_index)
		"wild": # spawn and "beeline"
			e.on_path = false
			e.global_position = global_position
		"random": #random, can swap road
			if rand_range(0, 1) < 0.5:
				e.global_position = global_position
			else:
				e.on_path = true
		
	# Determine phylactery
	e.target = world.get_node("Phylacteries").get_child(inital_index)
	
	world.get_node("Enemies").add_child(e)
	e.activate()
	
	spawned += 1
	if spawned == spawns_per_wave:
		$SpawnTimer.stop()
		
