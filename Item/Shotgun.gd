extends "res://Item/Item.gd"


func _on_Shotgun_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and !is_getting_picked:
		body.has_shotgun = true
		get_picked_up()

func handle_time(delta):
	pass
