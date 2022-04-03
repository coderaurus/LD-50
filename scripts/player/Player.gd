extends KinematicBody2D

signal hit
signal dead
signal enemy_down


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var velocity = Vector2.ZERO
var vulnerable = false

var souls = 5 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		velocity = Vector2.DOWN
	
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT
	
	if Input.is_action_just_pressed("heal"):
		heal_phylactery()
	
	if velocity != Vector2.ZERO:
		velocity.normalized()
		
		if velocity.x > 0 and $Sprite.flip_h:
			$Sprite.flip_h = false
		elif velocity.x < 0 and !$Sprite.flip_h:
			$Sprite.flip_h = true
			 
	
func _physics_process(delta):
	move_and_slide(velocity * speed)


func heal_phylactery():
	var phyla = $Aura.phylactery_in_aura
	var missing = phyla.get_node("Health").health_missing()
	if missing > 0 and souls >= missing:
		souls -= missing
		phyla.get_node("Health").emit_signal("heal", missing)
		get_tree().current_scene.show_souls(souls)


func show_health():
	$Health.show_health()


func _on_hit():
	$Health.emit_signal("hit")


func _on_dead():
	get_tree().current_scene.game_over()
	queue_free()


func is_vulnerable():
	return vulnerable


func _on_enemy_down():
	souls += 1
	get_tree().current_scene.show_souls(souls)
