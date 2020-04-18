extends KinematicBody2D

const MOVE_SPEED = 5
const MAX_SPEED = 100
const FULL_HP = 100
const FRICTION = 0
const KNOCKBACK = 100

const soul_scene = preload("res://Soul/Soul.tscn")

onready var map_navigation = get_parent().get_node('Navigation2D')
onready var sprite = $Sprite
onready var damage_sprite = $DamageSprite
onready var anim_player = $AnimationPlayer

var player
var hp = FULL_HP setget set_hp
var damage
var motion
var acceleration
var knockback

signal camera_shake_requested

func _ready():
	add_to_group('enemies')
	motion = Vector2.ZERO
	acceleration = Vector2.ZERO
	knockback = Vector2.ZERO
	connect("camera_shake_requested", get_tree().get_nodes_in_group('camera')[0], 'shake')

func _physics_process(delta):
	if player == null:
		player = get_tree().get_nodes_in_group('player')[0]
	search(delta)
	if knockback != Vector2():
		knockback = knockback.linear_interpolate(Vector2(), 0.5)

func search(delta):
	var starting_point = self.global_position
	var path_to_player = map_navigation.get_simple_path(starting_point, player.global_position)
	var move_distance = MOVE_SPEED * delta
	for point in range(path_to_player.size()):
		var distance_to_next_point = starting_point.distance_to(path_to_player[point])
		if move_distance <= distance_to_next_point:
			var move_rotation = get_angle_to(starting_point.linear_interpolate(path_to_player[point], move_distance / distance_to_next_point))
			acceleration = Vector2(MOVE_SPEED, 0).rotated(move_rotation) 
			acceleration = acceleration.linear_interpolate(Vector2.ZERO, FRICTION * delta)
			motion += acceleration + knockback
			motion = move_and_slide(motion).clamped(MAX_SPEED)
			break
		move_distance -= distance_to_next_point
		starting_point = path_to_player[point]
	if motion != Vector2() and !anim_player.is_playing():
		anim_player.play('move')

func recieve_damage(damage, knockback_direction):
	set_hp(damage)
	emit_signal('camera_shake_requested')
	#knockback = lerp(acceleration, knockback_direction * 5, 0.5)
	knockback = knockback_direction * KNOCKBACK
	anim_player.stop()
	sprite.visible = false
	damage_sprite.visible = true
	yield(get_tree().create_timer(0.1), 'timeout')
	sprite.visible = true
	damage_sprite.visible = false

func die():
	var soul = soul_scene.instance()
	soul.position = position
	get_tree().get_root().call_deferred('add_child', soul)
	queue_free()

func set_hp(damage):
	hp -= damage
	if hp <= 0:
		die()
