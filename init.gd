extends Node2D
var memb_path:PackedScene = load("res://membrane.tscn")
var mol_path:PackedScene = load("res://h_2o.tscn")
var ressort_path:PackedScene = load("res://ressort.tscn")

var nb:int = 72
var lst_memb:Array[RigidBody2D]
var box_size : Vector2 = Vector2(400, 400)
@export var density : int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Creation de la membrane
	var memb_r:float = 185  # rayon
	for m in range(nb):
		var a = m*2*PI / nb
		var pos:Vector2 = Vector2(box_size.x/2 + memb_r*cos(a) ,box_size.y/2 + memb_r*sin(a))
		# Creation d'un element de membrane
		var memb:RigidBody2D = memb_path.instantiate()
		memb.position = pos
		get_tree().root.add_child.call_deferred(memb)
		lst_memb.append(memb)
		
	# Creation des molécules d'eau
	var R : int = 10 + density  # espace entre 2 billes
	for y in range(400/R):
		for x in range(400/R):
			var pos_x = (R/2)*(y%2) + x * R
			var pos_y = 0 + y * R
			# Creation d'une molécule d'eau
			var mol:RigidBody2D = mol_path.instantiate()
			mol.position = Vector2(pos_x, pos_y)
			if (memb_r - R/2) < mol.position.distance_to(box_size/2) and mol.position.distance_to(box_size/2) < (memb_r + R/2):
				mol.queue_free()
			if mol.position.distance_to(box_size/2) > memb_r:
				mol._is_ext = true
			get_tree().root.add_child.call_deferred(mol)


var init:bool = false
func _process(_delta: float) -> void:
	if init == false:
		# Creation des ressorts
		for m in range(nb):
			var memb_a:RigidBody2D = lst_memb[m]
			var memb_b:RigidBody2D = lst_memb[(m+1)%nb]
			var memb_c:RigidBody2D = lst_memb[(m+2)%nb]
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
