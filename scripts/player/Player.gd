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

var souls = 0 

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
	
	if velocity != Vector2.ZERO:
		velocity.normalized()
	
func _physics_process(delta):
	move_and_slide(velocity * speed)


func show_health():
	$Health/AnimationPlayer.play("Show")


func _on_hit():
	$Health.emit_signal("hit")


func _on_dead():
	get_tree().current_scene.game_over()
	queue_free()


func is_vulnerable():
	return vulnerable


func _on_enemy_down():
	souls += 1
