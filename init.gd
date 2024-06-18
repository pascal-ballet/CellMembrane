extends Node2D
var memb_path:PackedScene = load("res://membrane.tscn")
var mol_path:PackedScene = load("res://h_2o.tscn")
var ressort_path:PackedScene = load("res://ressort.tscn")

var nb:int = 70
var lst_memb:Array[RigidBody2D]
var box_size : Vector2 = Vector2(400, 400)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Creation de la membrane
	var r:float = 185  # rayon
	for m in range(nb):
		var a = m*2*PI / nb
		var pos:Vector2 = Vector2(box_size.x/2 + r*cos(a) ,box_size.y/2 + r*sin(a))
		# Creation d'un element de membrane
		var memb:RigidBody2D = memb_path.instantiate()
		memb.position = pos
		get_tree().root.add_child.call_deferred(memb)
		lst_memb.append(memb)
	
	# Creation des molécules d'eau internes
	var R : int = 10  # R vaut 2 * r : l'espace entre 2 anneaux
	var r_h2o : int = 5  # r est le rayon d'une molécule d'eau
	var n : int = 700
	var ring : int = 0
	var n_on_ring : int = 1
	while n>0:
		var x : float = ring * R * cos(n_on_ring * 2*PI / get_n_on_ring(ring, R, r_h2o))
		var y : float = ring * R * sin(n_on_ring * 2*PI / get_n_on_ring(ring, R, r_h2o))
		# Creation d'une molécule d'eau
		var mol:RigidBody2D = mol_path.instantiate()
		mol.position = box_size/2 + Vector2(x, y)
		get_tree().root.add_child.call_deferred(mol)
		# Mise à jour des variables dans la boucle
		n_on_ring -= 1
		n -= 1
		if n_on_ring == 0:
			ring += 1
			n_on_ring = get_n_on_ring(ring, R, r_h2o)
	
	# Creation des molécules d'eau externes
	n = 500
	# Positionner un cercle autour de la membrane
	ring = 200/R
	for i in range(get_n_on_ring(ring, R, r_h2o)):
		var x : float = ring * R * cos(i * 2*PI / get_n_on_ring(ring, R, r_h2o))
		var y : float = ring * R * sin(i * 2*PI / get_n_on_ring(ring, R, r_h2o))
		# Creation d'une molécule d'eau
		var mol:RigidBody2D = mol_path.instantiate()
		mol.position = box_size/2 + Vector2(x, y)
		mol._is_ext = true
		get_tree().root.add_child.call_deferred(mol)
		n -= 1
	# Positionner le reste dans les 4 coins
	var corners : Array[Vector2] = [
		Vector2(0, 0),  # Coin haut gauche
		Vector2(box_size.x, box_size.y),  # Coin bas droite
		Vector2(box_size.x, 0),  # Coin haut droite
		Vector2(0, box_size.y)  # Coin bas gauche
	]
	var i : int = 0 
	while n>0:
		i += 1
		# Creation d'une molécule d'eau
		var mol:RigidBody2D = mol_path.instantiate()
		mol.position = corners[i%4]
		mol._is_ext = true
		get_tree().root.add_child.call_deferred(mol)
		n -= 1
		

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

func get_n_on_ring(ring:int, R:int, r:int) -> int:
	return int(2 * PI * ring)
