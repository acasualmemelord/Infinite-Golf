extends Camera3D

@onready var golf_ball = $".."

#Variables for raycast
const ray_length = 100
const normal = 4.1
const topdown = 15
var mouse_pos : Vector2
var from : Vector3
var to : Vector3
var space : PhysicsDirectSpaceState3D
var query : PhysicsRayQueryParameters3D

#Variable for camera follow
var y = 4.1
var vector : Vector3

func _ready() -> void:
	#We set the camera as top level to ignore parent's transformations. 
	#Otherwise, the camera will rotate violently.
	self.set_as_top_level(true)
		
func _process(_delta) -> void:
	#Function to follow golf ball.
	camera_follow()
	
func _input(event) -> void:
	#After the mouse is released, we calculate the speed and shoot the ball in the given direction.	
	if event.is_action_released("up"):
		if (y < topdown):
			y += 0.5
	elif event.is_action_released("down"):
		if (y > normal):
			y -= 0.5
			
#Function to follow golf ball.
func camera_follow() -> void:
	vector = Vector3(golf_ball.transform.origin.x, golf_ball.transform.origin.y + y, golf_ball.transform.origin.z)
	
	self.transform.origin = self.transform.origin.lerp(vector,1)
	
#Translating the mouse position from the screen into 3d world.
func camera_raycast():
	mouse_pos = get_viewport().get_mouse_position()
	from = project_ray_origin(mouse_pos) 
	to = from + project_ray_normal(mouse_pos) * ray_length
	space = get_world_3d().direct_space_state
	query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 3
	return space.intersect_ray(query)
