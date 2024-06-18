extends RigidBody2D

@export var _is_ext:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var screen_center : Vector2 = get_viewport_rect().size/2
	
	if _is_ext==false:
		# Disparition
		if randf() < 0.0005:
			var a:float = 2*PI*randf()
			var dest_x:float = 500 + 250 * cos(a)
			var dest_y:float = 300 + 250 * sin(a)
			global_translate(Vector2(dest_x-position.x, dest_y-position.y))
			_is_ext = true
			return
	else:
		# Rebond sur les bords
		if position.x < screen_center.x - 200:
			position.x = screen_center.x - 200
			linear_velocity.x = abs(linear_velocity.x)
		if position.x > screen_center.x + 200:
			position.x = screen_center.x + 200
			linear_velocity.x = - abs(linear_velocity.x)
		if position.y < screen_center.y - 200:
			position.y = screen_center.y - 200
			linear_velocity.y = abs(linear_velocity.y)
		if position.y > screen_center.y + 200:
			position.y = screen_center.y + 200
			linear_velocity.y = - abs(linear_velocity.y)

	# Force de Langevin
	var i:float = 500
	var fx:float = i * (randf()-0.5)
	var fy:float = i * (randf()-0.5)
	apply_force(Vector2( fx, fy))
