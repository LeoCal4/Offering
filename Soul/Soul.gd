extends Area2D

onready var anim_player = $AnimationPlayer

var center = 0
var rotation_speed = 3
var radius = 10
var angle = 0

func _ready():
	center = self.position

func _physics_process(delta):
	angle += rotation_speed * delta
	position = center + Vector2(sin(angle), cos(angle)) * radius


func _on_Soul_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.get_soul()
		queue_free()