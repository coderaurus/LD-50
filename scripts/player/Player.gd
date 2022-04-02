extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var velocity = Vector2.ZERO

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
