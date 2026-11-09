extends RigidBody2D
@onready var enemy_sprite: AnimatedSprite2D = $"Enemy sprite"
@onready var ray_cast_l: RayCast2D = $"../Ray cast L"
@onready var ray_cast_r: RayCast2D = $"../Ray cast R"

var impuls = false
var walking = 0.0
var stunned = false
var stunned_timer = 0.0
var in_collision_with_attack = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	ray_cast_l.position = position + Vector2(-15, 0)
	ray_cast_r.position = position + Vector2(15 , 0)
	if !ray_cast_l.is_colliding():
		walking = 60
	elif !ray_cast_r.is_colliding():
		walking = -60



func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !stunned:
		state.linear_velocity.x = walking


func _on_hit_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_collision_with_attack = false

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_collision_with_attack = true

func _process(delta: float) -> void:
	stunned_timer = maxf(stunned_timer - delta, 0.0)
	if Input.is_action_just_pressed("Attack") and in_collision_with_attack:
		stunned_timer = 4.0
		var player = get_node("../../Player/CharacterBody2D")
		var kierunek = 1.0 if global_position.x >= player.global_position.x else -1.0
		apply_central_impulse(Vector2(kierunek * 250.0, -120.0))
	stunned = stunned_timer > 0.0
