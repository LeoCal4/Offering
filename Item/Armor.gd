extends "res://Item/Item.gd"

func _on_Armor_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and !is_getting_picked:
		body.has_armor = true
		get_picked_up()

func handle_time(delta):
	pass