extends Node3D

# ##### Flux d'eau #####

var memb_path:PackedScene = load("res://membrane.tscn")
var mol_path:PackedScene = load("res://h_2o.tscn")
var ressort_path:PackedScene = load("res://ressort.tscn")

var lst_memb:Array[RigidBody3D]

var box_size : Vector2 
var density : int
var memb_r : float = General.memb_r
var nb:int = 2*PI*memb_r/16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialisation de variables
	General.box_size = Vector2(1300, 100)
	box_size = General.box_size
	General.density = -1
	density = General.density
	
	# Position de la caméra
	position.x = box_size.x/2
	position.y = box_size.y/2
	
	#  Creation des obstacles
	for i in range(3):
		var rx = randi_range(0, box_size.x)
		var ry = randi_range(0, box_size.y)
		var pos = Vector3(rx, ry, 0)
		# Creation d'un element de membrane
		var memb:RigidBody3D = memb_path.instantiate()
		memb.position = pos
		memb._global_scene = 1
		memb.axis_lock_linear_x = true
		memb.axis_lock_linear_y = true
		get_tree().root.add_child.call_deferred(memb)
		
		
	# Creation des molécules d'eau
	var R : int = 10 + density  # espace entre 2 billes
	for y in range(box_size.y/R + 1):
		for x in range(box_size.x/R + 1):
			var pos_x = (R/2)*(y%2) + x * R
			var pos_y = 0 + y * R
			# Creation d'une molécule d'eau
			var mol:RigidBody3D = mol_path.instantiate()
			mol.position = Vector3(pos_x, pos_y, 0)
			mol._global_scene = 1
			get_tree().root.add_child.call_deferred(mol)


var init:bool = false
func _process(_delta: float) -> void:
	pass
