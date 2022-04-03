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


func reload_map():
	get_parent().get_node("UI").fade_out()
	yield(get_parent().get_node("UI").get_node("FadeScreen/AnimationPlayer"), "animation_finished")
	clear_map()
	load_current_map()


func load_next_map():
	if get_parent().game_started:
		get_parent().get_node("UI").fade_out()
		yield(get_parent().get_node("UI").get_node("FadeScreen/AnimationPlayer"), "animation_finished")
	clear_map()
	current_map += 1
	load_current_map()


func load_current_map():
	# Add map to world
	var map = load(map_paths[current_map])
	map = map.instance()
	$Maps.add_child(map, true)
	
	
	for tile_layer in map.get_children():
		if tile_layer is TileMap:
			tile_layer.fix_invalid_tiles()


	player = get_node_or_null("Player")
	if player == null:
		player = player_scene.instance()
		add_child(player)
	
	# Place player
	var player_pos = map.get_node_or_null("PlayerCoord")
	if player_pos != null:
		print("  Set player position")
		player.global_position = player_pos.global_position
		
	# Place phylacteries
	var phyla_coords = map.get_node_or_null("PhylaCoords")
	if phyla_coords != null:
		for coord in phyla_coords.get_children():
			var phyla = phylactery_scene.instance()
			$Phylacteries.add_child(phyla)
			phyla.global_position = coord.global_position
	

#	print("Did we add map ", get_node("Map"))
	if get_parent().game_started:
		get_parent().get_node("UI").fade_in()
		yield(get_parent().get_node("UI").get_node("FadeScreen/AnimationPlayer"), "animation_finished")
	# Start map
	get_tree().paused = false
	map.start_map()



func clear_map():
	for phyla in $Phylacteries.get_children():
		phyla.queue_free()
	
	for enemy in $Enemies.get_children():
		enemy.queue_free()
		
	for corpse in $Corpses.get_children():
		corpse.queue_free()
	
	var last_map = get_node_or_null("Maps").get_child(0)
	if last_map != null:
		last_map.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
