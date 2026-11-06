extends CharacterBody2D
@onready var player_sprite: AnimatedSprite2D = $Player_sprite


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		player_sprite.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		player_sprite.frame = 0

	if direction < 0:
		player_sprite.flip_h = true
	elif direction > 0:
		player_sprite.flip_h = false

	move_and_slide()
