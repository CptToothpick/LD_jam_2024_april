class_name Interactable extends Area2D

var sprite2Dcomponent : Sprite2D
@export var highlightShader : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite2Dcomponent = get_parent().get_node('Sprite2D')

func onEnterClosest():
	changeColorToHighlight()
	
func onLeaveClosest():
	resetColor()
		
func changeColorToHighlight():
		sprite2Dcomponent.set_material(highlightShader)

func resetColor():
		sprite2Dcomponent.set_material(null)
