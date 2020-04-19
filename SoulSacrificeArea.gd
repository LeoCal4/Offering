extends Area2D

func _on_SoulSacrificeArea_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.can_sacrifice_souls = true
		if body.souls >= 0:
			body.soul_sacrifice_label.visible = true


func _on_SoulSacrificeArea_body_exited(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.can_sacrifice_souls = false
		body.soul_sacrifice_label.visible = false