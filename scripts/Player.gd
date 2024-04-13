extends CharacterBody2D

@export var Acceleration : int = 800
@export var MaxSpeed : int = 500
@export var Friction : int = 120

enum {IDLE,
	RUN_UP, RUN_DOWN, RUN_LEFT, RUN_RIGHT,
	RUN_UP_HOLDING, RUN_DOWN_HOLDING, RUN_LEFT_HOLDING, RUN_RIGHT_HOLDING
}
var state = IDLE

func _ready():
	set_process(true)

func _physics_process(delta):
	
	move(delta)
	print(velocity);

func move(delta):
	
	var direction = Input.get_vector('move_left','move_right','move_up',"move_down")	
	
	if direction == Vector2.ZERO:
		state = IDLE
		_apply_friction(Friction*delta)
	else:
		##TODO : make animation switch
		_apply_movement(direction*Acceleration*delta)
		
	move_and_slide()
	
func _apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
			
func _apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MaxSpeed)
