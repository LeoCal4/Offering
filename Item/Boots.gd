extends "res://Item/Item.gd"

func _on_Boots_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and !is_getting_picked:
		body.set_move_speed(300)
		get_picked_up()