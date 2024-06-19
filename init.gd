extends Node3D
var memb_path:PackedScene = load("res://membrane.tscn")
var mol_path:PackedScene = load("res://h_2o.tscn")
var ressort_path:PackedScene = load("res://ressort.tscn")

var lst_memb:Array[RigidBody3D]
var box_size : Vector2 = General.box_size
var density : int = General.density
var memb_r : float = General.memb_r
var nb:int = 2*PI*memb_r/16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Position de la caméra
	position.x = box_size.x/2
	position.y = box_size.y/2
	
	
	# Creation de la membrane
	for m in range(nb):
		var a = m*2*PI / nb
		var pos:Vector3 = Vector3(box_size.x/2 + memb_r*cos(a) ,box_size.y/2 + memb_r*sin(a), 0)
		# Creation d'un element de membrane
		var memb:RigidBody3D = memb_path.instantiate()
		memb.position = pos
		get_tree().root.add_child.call_deferred(memb)
		lst_memb.append(memb)
		
	# Creation des molécules d'eau
	var R : int = 10 + density  # espace entre 2 billes
	for y in range(box_size.y/R):
		for x in range(box_size.x/R):
			var pos_x = (R/2)*(y%2) + x * R
			var pos_y = 0 + y * R
			# Creation d'une molécule d'eau
			var mol:RigidBody3D = mol_path.instantiate()
			mol.position = Vector3(pos_x, pos_y, 0)
			var center : Vector3 = Vector3(box_size.x/2, box_size.y/2, 0)
			if (memb_r - R/2) < mol.position.distance_to(center) and mol.position.distance_to(center) < (memb_r + R/2):
				mol.queue_free()
			if mol.position.distance_to(center) > memb_r:
				mol._is_ext = true
			get_tree().root.add_child.call_deferred(mol)


var init:bool = false
func _process(_delta: float) -> void:
	if init == false:
		# Creation des ressorts
		for m in range(nb):
			var memb_a:RigidBody3D = lst_memb[m]
			var memb_b:RigidBody3D = lst_memb[(m+1)%nb]
			var memb_c:RigidBody3D = lst_memb[(m+2)%nb]
			# Creation d'un ressort
			var ressort = ressort_path.instantiate()
			ressort.node_1 = memb_a
			ressort.node_2 = memb_b
			get_tree().root.add_child.call_deferred(ressort)
			# Memo des membranes adjacentes
			memb_b.m_avant = memb_a
			memb_b.m_apres = memb_c
			
		init = true

func get_n_on_ring(ring:int) -> int:
	return int(2 * PI * ring)
