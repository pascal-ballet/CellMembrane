extends RigidBody3D

var m_avant:RigidBody3D
var m_apres:RigidBody3D

var _global_scene : int = 0
var box_size : Vector2 = General.box_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if _global_scene == 0:
		# Force de Langevin
		var i_l:float = 100
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
			
	elif _global_scene == 1:
		pass


func _on_body_entered(body):
	if self.is_in_group("")
