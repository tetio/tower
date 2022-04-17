extends Node

signal swiped(direction)
signal swiped_cancelled(start_position)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3

onready var timer = $Timer
var swipe_start_position = Vector2()
var isTouching = false
var last_direction = Vector2()

func _input(event):
	if event is InputEventScreenTouch and event.pressed and not isTouching:
		print("1")
		isTouching = true
		_start_detection(event.position)
	if event is InputEventScreenDrag and isTouching:
		print("2")
		new_position(event.position)
	if event is InputEventScreenTouch and not event.pressed:
		print("3")
		isTouching = false
		last_direction = Vector2()

func _start_detection(position):
	print("_start_detection (%d, %d)", [position.x, position.y])
	swipe_start_position = position
#	timer.start()
	
func _end_detection(position):
#	timer.stop()
	new_position(position)
	
func new_position(position): 
	if last_direction.x != 0 and last_direction.y != 0:
		return
	var direction = (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	if abs(direction.x) > abs(direction.y):
		last_direction = Vector2(direction.x, 0.0)
	else:
		last_direction = Vector2(0.0, direction.y)
	emit_signal('swiped', last_direction)

func _on_Timer_timeout():
	emit_signal('swiped_cancelled', swipe_start_position)
