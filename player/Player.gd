extends KinematicBody2D

const SPEED = 70
const STEP = 16
var move_dir = Vector2(0, 0)
var moving = 0
var spritedir = "down"

func _physics_process(delta):
	controls_loop()
	movement_loop()
	spritedir_loop()
	
	if is_on_wall():
		if spritedir == "left" and test_move(transform, Vector2(-1, 0)): 
			anim_switch("push") 
		if spritedir == "right" and test_move(transform, Vector2(1, 0)):
			anim_switch("push")
		if spritedir == "down" and test_move(transform, Vector2(0, 1)) :
			anim_switch("push")	
		if spritedir == "up" and test_move(transform, Vector2(0, -1)) :
			anim_switch("push")	
	elif move_dir != Vector2(0, 0):
		anim_switch("walk")
	else:
		anim_switch("iddle")

func controls_loop():
#	if moving > 0:
#		continue_movement()
#	else:
	check_movement()
	
func movement_loop():
	var motion = move_dir.normalized() * SPEED
	move_and_slide(motion, Vector2(0, 0))

func continue_movement():
	moving -= 1
	if (moving > 0):
		if (move_dir.x != 0):
			move_dir.x += 1*sign(move_dir.x)
		elif (move_dir.y != 0):
			move_dir.y += 1*sign(move_dir.y)

func check_movement():
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	if (left || right || up || down):
		moving = STEP
	move_dir.x = int(right) - int(left)
	move_dir.y = int(down) - int(up)
	
	
func spritedir_loop():
	match move_dir:
		Vector2(-1, 0):
			spritedir = "left" 
		Vector2(1, 0):
			spritedir = "right"
		Vector2(0, -1):
			spritedir = "up"
		Vector2(0, 1):
			spritedir = "down"
	
func anim_switch(animation):
	var newanim = str(animation, spritedir)
	if $Anim.current_animation != newanim:
		$Anim.play(newanim)