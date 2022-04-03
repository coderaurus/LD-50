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

func _ready():
	$Health/AnimationPlayer.play("Hide")

# Called when the node enters the scene tree for the first time.
func activate():
	respawn_point = global_position
	attacking = false
	distance_travelled = 0
	
#	print("%s activate"% self.name)
	if !on_path: # Wild aka beeline / Random -> beeline
#		print("   Wild or Random Wild")
		_check_target()
	elif followed_path.empty(): # Random -> path
#		print("   Random Path")
		var line = map.get_node("Road").get_child(rand_range(0, map.get_node("Road").get_child_count()))
		followed_path = line.points
		global_position = followed_path[0]
		target = followed_path[1]
#		print("Line ", line.name)
#		print("On path", followed_path)
	elif on_path: # On path
#		print("   Random Path")
		global_position = followed_path[0]
		target = followed_path[1]
	print("[%s] Targetting %s" % [self.name, target])
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
			var closest_distance = 10000
			var closest_phyla
			for phyla in world.get_node("Phylacteries").get_children():
				var distance = global_position.distance_to(phyla.global_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_phyla = phyla
			target = closest_phyla
		elif world.get_node_or_null("Player") != null:
			target = world.get_node("Player")
			
	if $RayCast2D.get_collider() == null and attacking:
		attacking = false
		


func navigate_and_move():
	if !on_path and is_instance_valid(target):
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
		$RayCast2D.cast_to = velocity
		$RayCast2D.cast_to.x = clamp($RayCast2D.cast_to.x/2, -42, 42)
		$RayCast2D.cast_to.y = clamp($RayCast2D.cast_to.y/2, -42, 42)
		
#		print($RayCast2D.cast_to)
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
	var old_pos = global_position
	velocity = move_and_slide(velocity)
	distance_travelled += old_pos.distance_to(global_position)
	var collider = $RayCast2D.get_collider()
	if collider != null and !attacking:
#		print("[%s] Attack %s " % [self.name, collider.name])
		if collider.is_in_group("phylactery") or collider.is_in_group("corpse") or (collider.name == "Player" and collider.is_vulnerable()):
			attacking = true
			attack_target = collider
			$AttackTime.start(0)
	
	

func _on_Enemy_hit():
	$Health.emit_signal("hit")


func _on_dead():
	var c = corpse.instance()
	c.global_position = global_position
	world.get_node("Corpses").add_child(c)
	get_tree().current_scene.get_node("World").get_node("Map").emit_signal("enemy_down")
	world.get_node("Player").emit_signal("enemy_down")
	queue_free()


func _on_attack():
#	print("Me", self)
	distance_travelled += 75
	if is_instance_valid(attack_target):
#	print("%s Attack %s" % [self.name, attack_target])
		attack_target.emit_signal("hit")
		if attack_target.get_node("Health").alive():
			$AttackCooldown.start()


func _on_attack_cooldown():
	print("On atk cd")
	if $RayCast2D.get_collider() != null:
		$AttackTime.start()
	else:
		attacking = false


func _on_stuck_check():
	# Enemy stuck, respawn
	print("Travelled distance ", distance_travelled)
	print("  Attacking: %s | On path: %s" % [attacking, on_path])
#	print("  Spawning back at %s" % respawn_point)
	if distance_travelled <= 450:
#		print("Respawning ", self)
		global_position = respawn_point
		transform.origin = respawn_point
		activate()
