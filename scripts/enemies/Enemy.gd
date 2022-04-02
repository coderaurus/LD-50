extends KinematicBody2D

signal hit
signal dead

export var on_path : bool = false

var followed_path : Array = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 50
var velocity = Vector2.ZERO
var target
var attack_target
var target_pos : Vector2
var path : Array
var attacking : bool = false
var attack_range = 24
var respawn_point : Vector2
var distance_travelled = 0

onready var world = get_tree().current_scene.get_node("World")
onready var map = world.get_node("Map")
onready var corpse = preload("res://scenes/corpses/Corpse.tscn")

# Called when the node enters the scene tree for the first time.
func activate():
	respawn_point = global_position
	attacking = false
	distance_travelled = 0
	
	if !on_path:
		_check_target()
	elif followed_path.empty():
		var line = map.get_node("Road").get_child(rand_range(0, map.get_node("Road").get_child_count()))
		followed_path = line.points
		global_position = followed_path[0]
		target = followed_path[1]
#		print("Line ", line.name)
#		print("On path", followed_path)
	else:
		global_position = followed_path[0]
		target = followed_path[1]
	
	$RespawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PathVisual.global_position = Vector2.ZERO
	if $Health.alive():
		_check_target()
		if !attacking:
			navigate_and_move()

func _check_target():
	if !is_instance_valid(target) and !on_path:
		if world.get_node("Phylacteries").get_child_count() > 0:
			target = world.get_node("Phylacteries").get_child(0)
		elif world.get_node("Player") != null:
			target = world.get_node("Player")
	elif attacking:
		attacking = false


func navigate_and_move():
	if !on_path:
		if target.global_position != target_pos:
			target_pos = target.global_position
	#		path = map.get_simple_path(map.get_child(0).world_to_map(global_position), map.get_child(0).world_to_map(target_pos), false)
			path = map.get_simple_path(global_position, target_pos, false)
	else:
		if target is Vector2 and target != target_pos:
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
	var previous_pos = global_position
	velocity = move_and_slide(velocity)
	distance_travelled += previous_pos.distance_to(global_position)
	if collision != null:
#		print(collision.collider.name)
		var distance = 1000
#		var distance = global_position.distance_to(collision.collider.global_position)
#		print("Distance to target", distance)
		if  (!(target is Vector2) and collision.collider == target) or collision.collider.is_in_group("corpse"):
			if collision.collider.get_node("Health").alive():
	#			print(collision.collider.name)
				if collision.collider.is_in_group("corpse"):
					distance = global_position.distance_to(collision.collider.global_position)
#					print("Corpse ahead, me at ", global_position)
	#				print("Corpse targeted")
					attack_target = collision.collider
				else:
	#				print("not a corpse")
					distance = global_position.distance_to(collision.collider.global_position)
			
#				print("Attack distance - ", distance)
#				print("Target - ", attack_target)
				if distance <= attack_range and !attacking and $AttackTime.is_stopped():
					attacking = true
					$AttackTime.start()
		
	

func _on_Enemy_hit():
	$Health.emit_signal("hit")


func _on_dead():
	var c = corpse.instance()
	c.global_position = global_position
	world.get_node("Corpses").add_child(c)
	get_tree().current_scene.get_node("World").get_node("Map").emit_signal("enemy_down")
	queue_free()


func _on_attack():
#	print("Me", self)
	distance_travelled += 75
	if attack_target == null or !is_instance_valid(attack_target):
#		print("Attack target not valid")
		if !(target is Vector2):
			attack_target = target
	
	if is_instance_valid(attack_target):
#		print("Attack target valid ", attack_target)
		#print("target ", target != null)
#		print("   Me at %s | target at %s " % [global_position, attack_target.global_position])
		
		var distance = global_position.distance_to(attack_target.global_position)
#		print("   Target in ", distance)
		if  distance <= attack_range:
#			print("Enough distance")
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


func _on_stuck_check():
	# Enemy stuck, respawn
#	print("Travelled distance ", distance_travelled)
#	print("  Attacking: %s | On path: %s" % [attacking, on_path])
#	print("  Spawning back at %s" % respawn_point)
	if distance_travelled <= 450:
#		print("Respawning ", self)
		global_position = respawn_point
		transform.origin = respawn_point
		activate()
