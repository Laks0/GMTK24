extends Node

var last_checkpoint : NodePath

func save_point(path : NodePath):
	last_checkpoint = path

func load_point(rat : Rata):
	var checkpoint := get_tree().get_root().get_node_or_null(last_checkpoint) as Checkpoint
	if checkpoint == null:
		return
	
	rat.global_position = checkpoint.global_position
	rat.camera.limit_bottom = checkpoint.limit_bottom
	rat.camera.limit_top = checkpoint.limit_top
	rat.camera.limit_right = checkpoint.limit_right
	rat.camera.limit_left = checkpoint.limit_left
