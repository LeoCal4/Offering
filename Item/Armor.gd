extends "res://Item/Item.gd"

func _on_Armor_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.has_armor = true
		queue_free()
