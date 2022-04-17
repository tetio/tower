extends KinematicBody2D


const SPEED = 70
const STEP = 16
var move_dir = Vector2(0, 0)
var moving = 0
var spritedir = Mov.LEFT

#func _ready():
#	var swipeDetector = get_node("SwipeDetector")
#	swipeDetector.connect("swiped", self, "_on_swiped")
#	swipeDetector.connect("swiped_cancelled", self, "_on_swiped_cancelled")

func _physics_process(delta):
#	controls_loop()
	movement_loop()
	spritedir_loop()
	
	if move_dir == Vector2(0, 0):
		anim_switch("idle")
#	elif is_on_wall():
	elif spritedir == Mov.LEFT and test_move(transform, Vector2(-1, 0)): 
		anim_switch("push") 
	elif spritedir == Mov.RIGHT and test_move(transform, Vector2(1, 0)):
		anim_switch("push")
	elif spritedir == Mov.DOWN and test_move(transform, Vector2(0, 1)) :
		anim_switch("push")	
	elif spritedir == Mov.UP and test_move(transform, Vector2(0, -1)) :
		anim_switch("push")	
	elif move_dir != Vector2(0, 0):
		anim_switch("walk")

#func controls_loop():
#	if moving > 0:
#		continue_movement()
#	else:
	#check_movement()
	
func movement_loop():
	continue_movement()
	if moving:
		var motion = move_dir.normalized() * SPEED
		move_and_slide(motion, Vector2(0, 0))

func continue_movement():
	moving -= 1
	if moving > 0:
		if (move_dir.x != 0):
			move_dir.x += 1*sign(move_dir.x)
		elif (move_dir.y != 0):
			move_dir.y += 1*sign(move_dir.y)
	else:
		moving = 0
		move_dir = Vector2(0, 0)

#func check_movement():
#	var left = Input.is_action_pressed("ui_left")
#	var right = Input.is_action_pressed("ui_right")
#	var up = Input.is_action_pressed("ui_up")
#	var down = Input.is_action_pressed("ui_down")
#	if (left || right || up || down):
#		moving = STEP
#	move_dir.x = int(right) - int(left)
#	move_dir.y = int(down) - int(up)
	
	
func spritedir_loop():
	if move_dir != Vector2(0,0):
		match move_dir.normalized():
			Vector2(-1, 0):
				spritedir = Mov.LEFT 
			Vector2(1, 0):
				spritedir = Mov.RIGHT
			Vector2(0, -1):
				spritedir = Mov.UP
			Vector2(0, 1):
				spritedir = Mov.DOWN
	
func anim_switch(animation):
	var newanim = str(animation, mov2Str(spritedir))
	if $Anim.current_animation != newanim:
		$Anim.play(newanim)
		
func mov2Str(mov):
	match mov:
		1:
			return "left"
		2:
			return "right"
		3:
			return "up"
		4:
			return "down"


func _on_swiped():
	pass
	
func _on_swiped_cancelled():
	pass
	
const Mov = {
	NONE = 0,
	LEFT = 1,
	RIGHT = 2,
	UP = 3,
	DOWN = 4
}


func _on_SwipeDetector_swiped(direction):
	if moving == 0:
		moving = STEP
		move_dir.x = direction.x
		move_dir.y = direction.y
		


func _on_SwipeDetector_swiped_cancelled(start_position):
	moving = 0
	#pass
