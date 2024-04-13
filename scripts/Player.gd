extends CharacterBody2D

@export var Acceleration : int = 800
@export var MaxSpeed : int = 500
@export var Friction : int = 120

@export var direction: Vector2 = Vector2.ZERO

@export var spriteIdle: Texture = null
@export var spriteRunRight: Texture = null

var sprite2D : Sprite2D = null

enum {IDLE,
	RUN_UP, RUN_DOWN, RUN_LEFT, RUN_RIGHT,
	RUN_UP_HOLDING, RUN_DOWN_HOLDING, RUN_LEFT_HOLDING, RUN_RIGHT_HOLDING
}
var state = IDLE

func _ready():
	sprite2D = find_child('Sprite2D')

func _physics_process(delta):
	
	move(delta)

func move(delta):
	
	direction = Input.get_vector('move_left','move_right','move_up',"move_down")	
	
	if direction == Vector2.ZERO:
		sprite2D.texture = spriteIdle
		_apply_friction(Friction*delta)
	else:
		sprite2D.texture = spriteRunRight
		##TODO : make animation switch
		_apply_movement(direction*Acceleration*delta)
		_apply_friction(Friction*delta)
	
	move_and_slide()
	
func _apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
			
func _apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MaxSpeed)
