extends RigidBody3D

var m_avant:RigidBody3D
var m_apres:RigidBody3D

var _global_scene : int = 0
var box_size : Vector2 = General.box_size

var ressort_path:PackedScene = load("res://ressort.tscn")
var is_liked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if _global_scene == 0 or _global_scene == 3 or _global_scene == 4 or _global_scene == 5:
		# Force de Langevin
		var i_l:float = 300
		var f_l:Vector3 = Vector3( i_l * (randf()-0.5), i_l * (randf()-0.5), 0)
		
		# Force de planitude
		var v_avant:Vector3 = (m_avant.position - position).normalized()
		var v_apres:Vector3 = (m_apres.position - position).normalized()
		var i_p_1:float = 20
		var ip_3:float = 5
		var f_p:Vector3 = i_p_1 * Vector3( v_avant+v_apres ) + (ip_3 * Vector3( v_avant+v_apres )) * (ip_3 * Vector3( v_avant+v_apres )) * (ip_3 * Vector3( v_avant+v_apres ))
		apply_force(f_l + f_p)
		
		# Rebond sur les bords
		if position.x < 0:
			position.x = 0
			linear_velocity.x = abs(linear_velocity.x)
		if position.x > box_size.x:
			position.x = box_size.x
			linear_velocity.x = - abs(linear_velocity.x)
		if position.y < 0:
			position.y = 0
			linear_velocity.y = abs(linear_velocity.y)
		if position.y > box_size.y:
			position.y = box_size.y
			linear_velocity.y = - abs(linear_velocity.y)


func _on_body_entered(body):
	if _global_scene == 3:
		if ((self.is_in_group("membrane1") and body.is_in_group("membrane2")) or (self.is_in_group("membrane2") and body.is_in_group("membrane1"))) and is_liked == false:
			if body.is_liked == false:
				var ressort = ressort_path.instantiate()
				ressort.node_1 = body
				ressort.node_2 = self
				get_tree().root.add_child.call_deferred(ressort)
				is_liked = true
	elif _global_scene == 4:
		var groups:Array[String] = ["membrane1", "membrane2", "membrane3"]
		for g1 in groups:
			var groups2:Array[String] = groups
			groups2.erase(g1)
			for g2 in groups2:
				if self.is_in_group(g1) and body.is_in_group(g2) and is_liked == false:
					if body.is_liked == false:
						var ressort = ressort_path.instantiate()
						ressort.node_1 = body
						ressort.node_2 = self
						get_tree().root.add_child.call_deferred(ressort)
						is_liked = true
	elif _global_scene == 5:
		var groups:Array[String] = ["membrane1", "membrane2", "membrane3", "membrane4"]
		for g1 in groups:
			var groups2:Array[String] = groups
			groups2.erase(g1)
			for g2 in groups2:
				if self.is_in_group(g1) and body.is_in_group(g2) and is_liked == false:
					if body.is_liked == false:
						var ressort = ressort_path.instantiate()
						ressort.node_1 = body
						ressort.node_2 = self
						get_tree().root.add_child.call_deferred(ressort)
						is_liked = true
