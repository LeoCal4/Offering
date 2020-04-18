extends KinematicBody2D

const MOVE_SPEED = 3000
const MAX_SPEED = MOVE_SPEED * 12
const SHOOT_DELAY = 0.1
const FRICTION = 10 
const MAX_HEALTH = 100
const DAMAGE = 30

onready var bullet_start_position = $BulletStartPosition
const bullet_scene = preload("res://Player/Bullet/Bullet.tscn")

var health
var move_dir
var velocity
var acceleration
var shoot_delay_timer
var can_shoot


func _ready():
	health = MAX_HEALTH
	move_dir = Vector2(0, 0)
	velocity = Vector2(0, 0)
	acceleration = Vector2.ZERO
	shoot_delay_timer = get_tree().create_timer(SHOOT_DELAY)
	can_shoot = true
	yield(get_tree(), 'idle_frame')
	get_tree().call_group('enemies', 'set_player', self)

func _physics_process(delta):
	_handle_movement_input()
	_handle_shooting()
	_apply_movement(delta)
	_apply_friction(delta)
	#look_at(get_global_mouse_position())

func _handle_movement_input():
	move_dir = Vector2.ZERO
	var move_dir_y = int(Input.is_action_pressed('down')) - int(Input.is_action_pressed('up'))
	var move_dir_x = int(Input.is_action_pressed('right')) - int(Input.is_action_pressed('left'))
	move_dir = Vector2(move_dir_x, move_dir_y).normalized()

func _apply_movement(delta):
	acceleration = move_dir * MOVE_SPEED * delta
	velocity += acceleration.clamped(MAX_SPEED)
	velocity = move_and_slide(velocity)

func _apply_friction(delta):
	velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION * delta)

func _handle_shooting():
	if Input.is_action_pressed('shoot') and can_shoot:
		can_shoot = false
		var bullet_instance = bullet_scene.instance()
		bullet_instance.position = bullet_start_position.get_global_position()
		bullet_instance.direction = -(self.global_position - get_global_mouse_position()).normalized()
		bullet_instance.damage = DAMAGE
		#bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_instance.speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		yield(get_tree().create_timer(SHOOT_DELAY), "timeout")
		can_shoot = true