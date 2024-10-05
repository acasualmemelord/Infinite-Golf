extends RigidBody3D

@export var max_speed : int = 12
@export var accel : int = 5

@onready var scaler = $Scaler
@onready var camera_3d = $Camera3D

var selected : bool = false
var velocity : Vector3
var speed : Vector3
var distance : float
var direction :Vector3

var moving: bool = false

func _ready() -> void:
	#We set the scaler as top level to ignore parent's transformations.
	#Otherwise, the camera will rotate violently.
	scaler.set_as_top_level(true)
	pass
	
#Checking if the golf ball is selected.
func _on_input_event(_camera, event, _position, _normal, _shape_idx) -> void:
	if event.is_action_pressed("left_mb") and (PlayerVariables.mode == "arcade" or PlayerVariables.strokes < PlayerVariables.maxStrokes):
		selected = true
		
func _input(event) -> void:
	#After the mouse is released, we calculate the speed and shoot the ball in the given direction.	
	if event.is_action_released("left_mb"):
		if selected:
			#Calculating the speed 
			speed = - (direction * distance * accel).limit_length(max_speed)
			
			shoot(speed)
		
		selected = false
		
func _process(_delta) -> void:
	# sanity check: stop ball from phasing through ground
	if self.position.y < 0.601497 and self.linear_velocity.y < -7 and self.position.distance_to(PlayerVariables.holePos) > 1:
		self.position.y = 0.601497
		
	# next level
	if self.position.y < -4:
		PlayerVariables.nextLevel()
		self.position.y = 21
	
	# function to follow the golf ball
	scaler_follow()
	pull_meter()
	
#Shooting the golf ball.
func shoot (vector:Vector3) -> void:
	velocity = Vector3(vector.x,0,vector.z)
	
	self.apply_impulse(velocity, Vector3.ZERO)
	PlayerVariables.stroke()
	
#Function to the follow golf ball.
func scaler_follow() -> void:
	scaler.transform.origin = scaler.transform.origin.lerp(self.transform.origin,.8)
	
func pull_meter() -> void:
	#Calling the raycast from the camera node.
	var ray_cast = camera_3d.camera_raycast()
	
	if not ray_cast.is_empty():
		#Calculating the distance between the golf ball and the mouse position.
		distance = self.position.distance_to(ray_cast.position)
		#Calculating the direction vector between golf ball ,and mouse position.
		direction = self.transform.origin.direction_to(ray_cast.position)
		#Looking at the mouse position in the 3D world.
		scaler.look_at(Vector3(ray_cast.position.x,position.y,ray_cast.position.z))
		
		if selected:
			#Scaling the scaler with limitation.
			scaler.scale.z = clamp(distance,0,2)
			
		else:
			#Resetting the scaler.
			scaler.scale.z = 0.01


func _physics_process(_delta: float) -> void:
	for node in get_colliding_bodies():
		if not node.is_in_group("Floor") and node.name == "StaticBody3D" and not PlayerVariables.difficulty == "hardcore":
			node.get_parent().queue_free()
