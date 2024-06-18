extends Node

var node_1:RigidBody2D = null
var node_2:RigidBody2D = null
var length_0:float = 10
var k:float = 15

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if node_1 == null or node_2 == null:
		return
	var length:float = node_1.position.distance_to(node_2.position)
	var f = k * (length-length_0)
	
	var force:Vector2 = f * (node_1.position - node_2.position) / length
	node_1.apply_force(-force)
	node_2.apply_force(force)
	
