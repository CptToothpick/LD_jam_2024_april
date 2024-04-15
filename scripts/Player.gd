extends CharacterBody2D

@export var Acceleration : int = 800
@export var MaxSpeed : int = 500
@export var Friction : int = 120

@export var direction: Vector2 = Vector2.ZERO

#Interaction area for items pick-up
@onready var interactableAreaCollisonShape: CollisionShape2D = $InteractionComponents/InteractionArea/CollisionShape2D

#All interactables nearby - will probably split into items and machines
var allInteractables = []
var closestInteractable : Interactable = null

var pickedUpItem : Item  = null

#Animation enums
enum {IDLE,
	WALK,
	WALK_HOLDING
}

var state = IDLE

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]

var blendPositionPath = [
	"parameters/idle/idle_blend_space_2D/blend_position",
	"parameters/walk/walk_blend_space_2D/blend_position"
]

var animTreeStateKeys = [
	"idle",
	"walk"
]

@onready var pickUpPoint = $PickUpPoint


#Handling of closest Interactables
func _handleInteractablePositions():
	
	if len(allInteractables) == 0 && closestInteractable != null:
		closestInteractable.onLeaveClosest()
		closestInteractable = null
	
	if len(allInteractables) == 1:
		
		if(closestInteractable != allInteractables[0] && closestInteractable !=null):
			closestInteractable.onLeaveClosest()
			closestInteractable = allInteractables[0]
			closestInteractable.onEnterClosest()
	
		if(closestInteractable == null):		
			closestInteractable = allInteractables[0]
			closestInteractable.onEnterClosest()
	
	if len(allInteractables) >= 2:
		allInteractables.sort_custom(_sortInteractables)
		
		
		
		if allInteractables[0] != closestInteractable:
			for i in allInteractables:
				printraw(position.distance_to(i.position),",")
			if closestInteractable != null:
				closestInteractable.onLeaveClosest()
			closestInteractable = allInteractables[0]
			closestInteractable.onEnterClosest()
			

func _sortInteractables(a :Area2D, b:Area2D):
	if interactableAreaCollisonShape.global_position.distance_to(a.global_position) < interactableAreaCollisonShape.global_position.distance_to(b.global_position):
		return true
	return false 

#Basic processes
func _process(delta):
	_handleInteractablePositions()
	_handleActionInput()

func _physics_process(delta):
	move(delta)
	animate()

#movement functions
func move(delta):
	var moveDirection = Input.get_vector('move_left','move_right','move_up',"move_down")	
	
	if moveDirection == Vector2.ZERO:
		state = IDLE
		_apply_friction(Friction*delta)
	else:
		direction = moveDirection
		state = WALK
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

#animation

func animate() -> void:
	stateMachine.travel(animTreeStateKeys[state])
	animationTree.set(blendPositionPath[state], direction)

##Interaction funcitons

func _on_interaction_area_area_entered(area):
	allInteractables.insert(0,area)


func _on_interaction_area_area_exited(area):
	allInteractables.erase(area)

func _handleActionInput():
	if Input.is_action_just_pressed('action_one'):
		_handleInputOne();
	if Input.is_action_just_pressed("action_two"):
		pass

func _handleInputOne():
	if pickedUpItem:
		pickedUpItem.onDrop()
		pickedUpItem = null
	else:
		if closestInteractable && !pickedUpItem:
			pickedUpItem = closestInteractable.get_parent();
			pickedUpItem.onPickup(pickUpPoint)
	
	
