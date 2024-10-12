extends RigidBody3D

@export var max_speed : int = 20
@export var accel : int = 5

@onready var scaler = $Scaler
@onready var camera_3d = $Camera3D

var selected : bool = false
var velocity : Vector3
var speed : Vector3
var distance : float
var direction :Vector3

var moving: bool = false

var soundPlayer
var hitSound
var landSound
var wallSound
var holeSound

func _ready() -> void:
	scaler.set_as_top_level(true)
	soundPlayer = AudioStreamPlayer.new()
	self.add_child(soundPlayer)
	soundPlayer.bus = &"SFX"
	hitSound = preload("res://assets/hit.wav")
	landSound = preload("res://assets/land.wav")
	holeSound = preload("res://assets/hole.wav")
		
func _input(_event) -> void:
	if (not PlayerVariables.paused) and (PlayerVariables.mode == "arcade" or PlayerVariables.strokes < PlayerVariables.maxStrokes):
		pass
	if _event.is_action_pressed("jump"):
		self.linear_velocity.y += 5
	if _event.is_action_pressed("left_mb"):
		selected = true
	#After the mouse is released, we calculate the speed and shoot the ball in the given direction.	
	if _event.is_action_released("left_mb"):
		if selected:
			#Calculating the speed 
			speed = -(direction * distance * accel).limit_length(max_speed)
			if speed.length() > 1:
				shoot(speed)
		
		selected = false
		
func _process(_delta) -> void:
	# sanity check: stop ball from phasing through ground
	if self.position.y < 0.601497 and self.linear_velocity.y < -7 and self.position.distance_to(PlayerVariables.holePos) > 1:
		self.position.y = 0.601497
	
	# sanity check: stop ball from flying out of the field
	if self.position.x > 10:
		self.position.x = 9.5
	if self.position.x < -10:
		self.position.x = -9.5
	if self.position.z > 10:
		self.position.z = 9.5
	if self.position.z < -10:
		self.position.z = -9.5
		
	# next level
	if self.position.y < -4:
		PlayerVariables.nextLevel()
		self.position.y = 21
		
	if PlayerVariables.strokes == PlayerVariables.maxStrokes and my_equal_approx(self.linear_velocity, Vector3.ZERO):
		PlayerVariables.lose()
	
	# function to follow the golf ball
	scaler_follow()
	pull_meter()
	
#Shooting the golf ball.
func shoot (vector:Vector3) -> void:
	velocity = Vector3(vector.x,0,vector.z)
	
	self.apply_impulse(velocity, Vector3.ZERO)
	soundPlayer.stream = hitSound
	soundPlayer.play()
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
			# Scaling the scaler with limitation
			scaler.scale.z = -clamp(distance, 0, 2)

			# Create the new material
			var material = StandardMaterial3D.new()
			material.albedo_color = get_color_based_on_distance(distance)

			# Get the MeshInstance3D node and apply the material
			var mesh_instance = scaler.get_node("Mesh")
			mesh_instance.set_surface_override_material(0, material)
			
		else:
			#Resetting the scaler.
			scaler.scale.z = 0.01

func get_color_based_on_distance(length: float) -> Color:
	if length <= 3:
		# Lerp between green (0,1,0) and yellow (1,1,0)
		var t = length / 3.0
		return Color(lerp(0.0, 1.0, t), 1.0, 0.0)
	elif length <= 6:
		# Lerp between yellow (1,1,0) and red (1,0,0)
		var t = (length - 3.0) / 3.0
		return Color(1.0, lerp(1.0, 0.0, t), 0.0)
	else:
		# If length is greater than 6, return red (1,0,0)
		return Color(1.0, 0.0, 0.0)

func _physics_process(_delta: float) -> void:
	for node in get_colliding_bodies():
		if not node.is_in_group("Floor"):
			if node.name == "StaticBody3D":
				node.get_parent().hit()
		else:
			if self.position.y < -0.5:
				soundPlayer.stream = holeSound
				soundPlayer.play()
			if self.linear_velocity.y < -5:
				soundPlayer.stream = landSound
				soundPlayer.play()

func my_equal_approx(a: Vector3, b: Vector3) -> bool:
	return abs(a - b).length() < 0.01
