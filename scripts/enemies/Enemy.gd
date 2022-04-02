extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 75
var velocity = Vector2.ZERO
var target
var target_pos : Vector2
var path : Array

onready var world = get_tree().current_scene.get_node("World")
onready var map = world.get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	choose_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PathVisual.global_position = Vector2.ZERO
	navigate_and_move()


func choose_target():
	# Check for closest phylactery
	
	# If none available, target player
	target = world.get_node("Player")


func navigate_and_move():
	if target.global_position != target_pos:
		target_pos = target.global_position
#		path = map.get_simple_path(map.get_child(0).world_to_map(global_position), map.get_child(0).world_to_map(target_pos), false)
		path = map.get_simple_path(global_position, target_pos, false)
		
		print(path)
	$PathVisual.points = path
	
	# Get path
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		# Reach point, pop it from the list
		if global_position == path[1] or global_position.distance_to(path[1]) < 8:
			path.pop_front()
			
	# Move
	velocity = move_and_slide(velocity)
