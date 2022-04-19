extends Node

signal swiped(direction)
signal swiped_cancelled(start_position)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3

onready var timer = $Timer
var swipe_start_position = Vector2()
var current_position = Vector2()
var is_touching = false
var last_direction = Vector2()

func _input(event):
	

	
	if event is InputEventScreenTouch and event.pressed and not is_touching:
#		print("1")
		is_touching = true
		_start_detection(event.position)
#	if is_touching and event is InputEventScreenTouch and event.pressed:
##		pass
#		print("2")
#		# new_position(event.position)
#		current_position = event.position
	if is_touching and event is InputEventScreenDrag:
#		print("2.2")
		current_position = event.position
		
	if event is InputEventScreenTouch and not event.pressed and is_touching:
#		print("3")
		is_touching = false
		last_direction = Vector2()


func _start_detection(position):
	# print("_start_detection (%d, %d)", [position.x, position.y])
	swipe_start_position = position
	timer.start()
	
func _end_detection(position):
#	timer.stop()
	# new_position(position)
#	print("_end_detection")
	pass
	
func new_position(): 
	if last_direction.x != 0 or last_direction.y != 0:
		emit_signal('swiped', last_direction)
		return
	var direction = (current_position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	if abs(direction.x) > abs(direction.y):
		last_direction = Vector2(direction.x, 0.0)
	else:
		last_direction = Vector2(0.0, direction.y)

func _on_Timer_timeout():
	print(4)
	if is_touching:
		print(5)
		new_position()
		timer.start()
	else:
		emit_signal('swiped_cancelled', swipe_start_position)
