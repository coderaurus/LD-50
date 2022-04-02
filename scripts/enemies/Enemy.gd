extends KinematicBody2D

signal hit
signal dead

export var on_path : bool = false

var followed_path : Array = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 75
var velocity = Vector2.ZERO
var target
var attack_target
var target_pos : Vector2
var path : Array
var attacking : bool = false
var attack_range = 24

onready var world = get_tree().current_scene.get_node("World")
onready var map = world.get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	if !on_path:
		_check_target()
	else:
		var line = map.get_node("Road").get_child(rand_range(0, map.get_node("Road").get_child_count()))
		followed_path = line.points
		global_position = followed_path[0]
		target = followed_path[1]
#		print("Line ", line.name)
#		print("On path", followed_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PathVisual.global_position = Vector2.ZERO
	_check_target()
	if !attacking:
		navigate_and_move()

func _check_target():
	if !is_instance_valid(target) and !on_path:
		if world.get_node("Phylacteries").get_child_count() > 0:
			target = world.get_node("Phylacteries").get_child(0)
		elif world.get_node("Player") != null:
			target = world.get_node("Player")


func navigate_and_move():
	if !on_path:
		if target.global_position != target_pos:
			target_pos = target.global_position
	#		path = map.get_simple_path(map.get_child(0).world_to_map(global_position), map.get_child(0).world_to_map(target_pos), false)
			path = map.get_simple_path(global_position, target_pos, false)
	else:
		if target != target_pos:
			target_pos = target
	#		path = map.get_simple_path(map.get_child(0).world_to_map(global_position), map.get_child(0).world_to_map(target_pos), false)
			path = map.get_simple_path(global_position, target_pos, false)
#		print(path)
#	$PathVisual.points = path
	
	# Get path
	if path.size() > 1:
		velocity = global_position.direction_to(path[1]) * speed
#		$RayCast2D.cast_to = velocity
		# Reach point, pop it from the list
		if global_position == path[1] or global_position.distance_to(path[1]) < 8:
			path.pop_front()
	elif on_path:
		if followed_path.size() > 1:
			followed_path.pop_front()
			if followed_path.size() > 1:
				target = followed_path[1]
		else:
			on_path = false
			_check_target()
		
	# Test collision
	var collision = move_and_collide(velocity, true, true, true)
	# Move
	velocity = move_and_slide(velocity)
	if collision != null:
#		print(collision.collider.name)
		var distance = 1000
#		var distance = global_position.distance_to(collision.collider.global_position)
#		print("Distance to target", distance)
		if  (!(target is Vector2) and collision.collider == target) or collision.collider.is_in_group("corpse"):
#			print(collision.collider.name)
			if collision.collider.is_in_group("corpse"):
				distance = global_position.distance_to(collision.collider.global_position)
#				print("Corpse targeted")
				attack_target = collision.collider
			else:
#				print("not a corpse")
				distance = global_position.distance_to(collision.collider.global_position)
		
			if distance <= attack_range and !attacking:
				attacking = true
#				print("Attack")
				$AttackTime.start()
		
	

func _on_Enemy_hit():
	$Health.emit_signal("hit")


func _on_dead():
	queue_free()


func _on_attack():
	if attack_target == null or !is_instance_valid(attack_target):
		if !(target is Vector2):
			attack_target = target
	
	if is_instance_valid(attack_target):
#		print("target ", target != null)
#		print("me", global_position)
		var distance = global_position.distance_to(attack_target.global_position)
#		print(distance)
		if  distance <= attack_range:
			attack_target.emit_signal("hit")
			if attack_target.get_node("Health").alive():
				$AttackCooldown.start()
		else:
#			print("Not attacking")
			attacking = false
	else:
		attacking = false


func _on_attack_cooldown():
	$AttackTime.start()
