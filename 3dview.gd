extends Marker3D

var draging = false
var mousepos = Vector2(0.0,0.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#rotate_object_local(Vector3(0, 1, 0), (-mousepos.x/100000))
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			draging=event.pressed
				
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scale=scale + Vector3(0.02,0.02,0.02)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scale=scale - Vector3(0.02,0.02,0.02)
			
	if event is InputEventMouseMotion:
		if draging:
			mousepos=event.relative
			rotate_object_local(Vector3(0, 1, 0), (-mousepos.x/1000)) # first rotate in Y
			rotate_object_local(Vector3(1, 0, 0), (-mousepos.y/1000)) # then rotate in X
			rotation.z=0
			
			print(rotation_degrees.x)
			if rotation_degrees.x<-70: rotation_degrees.x=-70
			if rotation_degrees.x>70: rotation_degrees.x=70


			
			
				

