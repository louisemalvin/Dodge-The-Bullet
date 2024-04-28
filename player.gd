extends Area2D
#Add
@export var dodge_cooldown = 0.5
@export var speed = 400 # How fast the player will move (pixels/sec).
@export var dodge_multiplier = 2
@export var dodge_duration = 0.2
var dodge_timer = 0.0
var cooldown_timer = 0.0
var screen_size # Size

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("dodge") and is_dodge_ready():
		dodge_timer += dodge_duration
		cooldown_timer += dodge_cooldown
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if dodge_timer > 0.0:
			velocity *= dodge_multiplier
			dodge_timer -= delta
		
			
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
	
func is_dodge_ready():
	return cooldown_timer <= 0.0
	
