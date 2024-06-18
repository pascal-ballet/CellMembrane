extends RigidBody2D

var m_avant:RigidBody2D
var m_apres:RigidBody2D

var box_size : Vector2 = Vector2(400, 400)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Force de Langevin
	var i_l:float = 100
	var f_l:Vector2 = Vector2( i_l * (randf()-0.5), i_l * (randf()-0.5))
	
	# Force de planitude
	var v_avant:Vector2 = (m_avant.position - position).normalized()
	var v_apres:Vector2 = (m_apres.position - position).normalized()
	var i_p:float = 5
	var f_p:Vector2 = i_p * Vector2( v_avant+v_apres )
	
	apply_force(f_l + f_p * f_p * f_p)
	
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
