extends CharacterBody3D


var speed_multiplier = 3 # Multiplier used for controlling speed in certain situations E.G low health/injury, low stamina, crouching, ect...
var jump_height = 2.0 # How high the player can jump

var isCrawling = false
var isCrouching = false

var sprint_speed = 3.75
var walk_speed = 3
var crouch_speed = 2
var crouch_sprint_speed = 2.7
var crawl_speed = .75
var crawl_sprint_speed = 1.25

var default_fov = 75
var sprint_fov = 90

var mouse_sensitivity = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var foot = $foot # Raycast for floor detection
@onready var camera = $head/Camera3D # Main FPS viewing camera
@onready var head = $head # Parent of the camera is used for

@onready var concrete1 = preload("res://Assets/Concrete 1.wav")
@onready var concrete2 = preload("res://Assets/Concrete 2.wav")
@onready var concrete3 = preload("res://Assets/Concrete 3.wav")
@onready var concrete4 = preload("res://Assets/Concrete 4.wav")

var original_camera_pos = Vector3()

func _ready():
	# Sets the mouse to captured/hidden thus not showing on screen whilst still allowing free look in 3D
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Looking around using the mouse
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity)) # 
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # Clamp rotation


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or foot.is_colliding()):
		if not isCrawling and not isCrouching:
			velocity.y = jump_height
			step = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction:
		velocity.x = direction.x * speed_multiplier
		velocity.z = direction.z * speed_multiplier
		$head/AnimationPlayer.play("headbob")
		footsteps()
		if Input.is_action_pressed("Sprint") and Input.is_action_pressed("Forward"):
			if isCrouching:
				speed_multiplier = crouch_sprint_speed
				$head/AnimationPlayer.speed_scale = crouch_sprint_speed / walk_speed
			elif isCrawling:
				speed_multiplier = crawl_sprint_speed
				$head/AnimationPlayer.speed_scale = crawl_sprint_speed / walk_speed
			else:
				speed_multiplier = sprint_speed
				$head/AnimationPlayer.speed_scale = sprint_speed / walk_speed
		else:
			if isCrouching:
				speed_multiplier = crouch_speed
				$head/AnimationPlayer.speed_scale = crouch_speed / walk_speed
			elif isCrawling:
				speed_multiplier = crawl_speed
				$head/AnimationPlayer.speed_scale = crawl_speed / walk_speed
			else:
				speed_multiplier = walk_speed
				$head/AnimationPlayer.speed_scale = 1
	else:
		velocity.x = move_toward(velocity.x, 0, speed_multiplier)
		velocity.z = move_toward(velocity.z, 0, speed_multiplier)
		$head/AnimationPlayer.stop(true)
		camera.position = lerp(camera.position, original_camera_pos, 0.1)
	
	move_and_slide()
	
	if not $AnimationPlayer.is_playing():
		if Input.is_action_just_pressed("crouch"):
			if isCrouching == false:
				movementStateChange("crouch")
				speed_multiplier = crouch_speed
			elif isCrouching == true:
				movementStateChange("uncrouch")
				speed_multiplier = walk_speed
		elif Input.is_action_just_pressed("crawl"):
			if isCrawling == false:
				movementStateChange("crawl")
				speed_multiplier = crawl_speed
			elif isCrawling == true:
				movementStateChange("uncrawl")
				speed_multiplier = walk_speed
	

func movementStateChange(changeType):
	match changeType:
		"crouch":
			if isCrawling:
				$AnimationPlayer.play_backwards("crouch_to_crawl")
				isCrawling = false
				isCrouching = true
			else:
				$AnimationPlayer.play("standing_to_crouch")
				isCrouching = true
				changeCollisionShapeTo("crouching")
				isCrawling = false
			
		"uncrouch":
			$AnimationPlayer.play_backwards("standing_to_crouch")
			isCrouching = false
			isCrawling = false
			changeCollisionShapeTo("standing")
 
		"crawl":
			if isCrouching:
				$AnimationPlayer.play("crouch_to_crawl")
				isCrawling = true
				isCrouching = false
			else:
				$AnimationPlayer.play("standing_to_crawl")
				isCrouching = false
				isCrawling = true
				changeCollisionShapeTo("crawling")
 
		"uncrawl":
			$AnimationPlayer.play_backwards("standing_to_crawl")
			isCrawling = false
			isCrouching = false
			changeCollisionShapeTo("standing")
	


#Change collision shapes for standing, crouch, crawl
func changeCollisionShapeTo(shape):
	match shape:
		"crouching":
			#Disabled == false is enabled!
			$crouching.disabled = false
			$crawling.disabled = true
			$standing.disabled = true
		"standing":
			#Disabled == false is enabled!
			$standing.disabled = false
			$crawling.disabled = true
			$crouching.disabled = true
		"crawling":
			#Disabled == false is enabled!
			$crawling.disabled = false
			$standing.disabled = true
			$crouching.disabled = true

@export var step = false

func footsteps():
	if step:
		var array = [concrete1, concrete2, concrete3, concrete4]
		var rand_step_noise = array[randi() % array.size()]
		var sound_node = AudioStreamPlayer3D.new()
		get_node("/root/Global").add_child(sound_node)
		sound_node.stream = rand_step_noise
		sound_node.volume_db = -12
		sound_node.play()
		step = false



