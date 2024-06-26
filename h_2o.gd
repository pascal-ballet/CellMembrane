extends RigidBody3D


@export var _is_ext:bool = false
var _global_scene : int = 0
var box_size : Vector2 = General.box_size

func _ready() -> void: 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _global_scene == 0:
		if _is_ext==false:
			# Disparition
			if randf() < 0.0005:
				var a:float = 2*PI*randf()
				var dest_x:float = box_size.x/2 + 1.5 * box_size.x * cos(a)
				var dest_y:float = box_size.y/2 + 1.5 * box_size.y * sin(a)
				global_translate(Vector3(dest_x-position.x, dest_y-position.y, 0))
				_is_ext = true
				return
		else:
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

		# Force de Langevin
		var i:float = 500
		var fx:float = i * (randf()-0.5)
		var fy:float = i * (randf()-0.5)
		apply_force(Vector3( fx, fy, 0))
		
	elif _global_scene == 1:
		# Force du courant
		var i:float = 5
		var f = Vector3(i, 0, 0)
		apply_force(f)
		
		# Rebond sur les bords
		if position.y < 0:
			position.y = 0
			linear_velocity.y = abs(linear_velocity.y)
		if position.y > box_size.y:
			position.y = box_size.y
			linear_velocity.y = - abs(linear_velocity.y)
		if position.x < 0:
			position.x = 0
			linear_velocity.x = abs(linear_velocity.x)
		if position.x > box_size.x:
			position.x = 0

