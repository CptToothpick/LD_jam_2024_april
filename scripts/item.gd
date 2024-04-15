class_name Item extends Node2D

enum TYPE 
{
	EGG,
	FLOWER,
	GEL,
	MILK
}

@onready var holdingPoint : Node2D = null

var type : TYPE

func _ready():
	var rng = RandomNumberGenerator.new()
	type = rng.randi_range(0,len(TYPE)-1)

func _physics_process(delta):
	if holdingPoint:
		global_position = holdingPoint.global_position

func onPickup(point: Node2D):
	holdingPoint = point

func onDrop():
	holdingPoint = null
