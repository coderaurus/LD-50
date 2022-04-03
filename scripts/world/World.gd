extends Node2D

onready var player_scene = preload("res://scenes/player/Player.tscn")
onready var phylactery_scene = preload("res://scenes/player/Phylactery.tscn")

export var map_paths : Array	= []
var current_map = -1
var player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_next_map()
	pass # Replace with function body.

func load_next_map():
	clear_map()
	current_map += 1
	var map = load(map_paths[current_map])
	map = map.instance()
	
	if get_node_or_null("Player") == null:
		player = player_scene.instance()
		add_child(player)
	
	# Place player
	var player_pos = map.get_node_or_null("PlayerCoords")
	if player_pos != null:
		player.global_position = player_pos.global_position
		
	# Place phylacteries
	var phyla_coords = map.get_node_or_null("PhylaCoords")
	if phyla_coords != null:
		for coord in phyla_coords.get_children():
			var phyla = phylactery_scene.instance()
			phyla.global_position = coord.global_position
			$Phylacteries.add_child(phyla)
	
	# Add map to world
	add_child(map)
	print("Did we add map ", get_node("Map"))
	
	# Start map
	map.start_map()
	

func clear_map():
	var last_map = get_node_or_null("Map")
	if last_map != null:
		last_map.queue_free()
		
	for phyla in $Phylacteries.get_children():
		phyla.queue_free()
	
	for enemy in $Enemies.get_children():
		enemy.queue_free()
		
	for corpse in $Corpses.get_children():
		corpse.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
