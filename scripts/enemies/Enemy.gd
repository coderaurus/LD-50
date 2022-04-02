extends KinematicBody2D

signal hit
signal dead

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 75
var velocity = Vector2.ZERO
var target
var target_pos : Vector2
var path : Array
var attacking : bool = false
var attack_range = 16

onready var world = get_tree().current_scene.get_node("World")
onready var map = world.get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	choose_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PathVisual.global_position = Vector2.ZERO
	_check_target()
	if !attacking:
		navigate_and_move()

func _check_target():
	if !is_instance_valid(target):
		if world.get_node("Phylacteries").get_child_count() > 0:
			target = world.get_node("Phylacteries").get_child(0)
		elif world.get_node("Player") != null:
			target = world.get_node("Player")


func choose_target():
	# Check for closest phylactery
	
	# If none available, target player
#	target = world.get_node("Player")
	_check_target()


func navigate_and_move():
	if target.global_position != target_pos:
		target_pos = target.global_position
#		path = map.get_simple_path(map.get_child(0).world_to_map(global_position), map.get_child(0).world_to_map(target_pos), false)
		path = map.get_simple_path(global_position, target_pos, false)
		
#		print(path)
	$PathVisual.points = path
	
	# Get path
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		# Reach point, pop it from the list
		if global_position == path[1] or global_position.distance_to(path[1]) < 8:
			path.pop_front()
			
	# Test collision
	var collision = move_and_collide(velocity, true, true, true)
	# Move
	velocity = move_and_slide(velocity)
	if collision != null:
		var distance = global_position.distance_to(collision.collider.global_position)
#		print("Distance to target", distance)
		if collision.collider == target and distance <= attack_range:
			if !attacking:
				attacking = true
				print("Attack")
				$AttackTime.start()
		
	

func _on_Enemy_hit():
	$Health.emit_signal("hit")


func _on_dead():
	queue_free()


func _on_attack():
	if is_instance_valid(target):
#		print("target ", target != null)
#		print("me", global_position)
		var distance = global_position.distance_to(target.global_position)
		print(distance)
		if  distance <= attack_range:
			target.emit_signal("hit")
			$AttackCooldown.start()
		else:
			print("Not attacking")
			attacking = false


func _on_attack_cooldown():
	$AttackTime.start()
