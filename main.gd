extends Node
# just an example, print is already send outputs to web consolle 

@onready var label_p12 = $Screen/ColorRect/VBoxContainer/label_p12
@onready var label_p11 = $Screen/ColorRect/VBoxContainer/label_p11
@onready var space = $"3dspace"

var console = JavaScriptBridge.get_interface("console")

var externalator = JavaScriptBridge.get_interface("externalator")
var _js_cb_draw_pose_landmark = JavaScriptBridge.create_callback(cbDrawPoseLandmark)
var _js_cb_draw_left_hand_landmark = JavaScriptBridge.create_callback(cbDrawLeftHandLandmark)
var _js_cb_draw_right_hand_landmark = JavaScriptBridge.create_callback(cbDrawRightHandLandmark)
var _js_cb_draw_face_landmark = JavaScriptBridge.create_callback(cbDrawFaceLandmark)

#var linesLeftHand:Array
var linelist=[]

var llen=21# mediapipe constant
var l = []

#var linesRightHand:Array
var rlen=21# mediapipe constant
var r = []

#var linesPose:Array
var plen=33# mediapipe constant
var p = []

#var linesFace:Array
var flen=468# mediapipe constant
var f = []

func cbDrawPoseLandmark(args):
	plen = args[1]
	p.clear()
	for i in range(args[1]):
		p.append([args[0][i][0],args[0][i][1],args[0][i][2],args[0][i][3]])
		

func cbDrawRightHandLandmark(args):
	rlen = args[1]
	r.clear()
	for i in range(args[1]):
		r.append([args[0][i][0],args[0][i][1],args[0][i][2],args[0][i][3]])
	#print(r)

func cbDrawLeftHandLandmark(args):
	llen = args[1]
	l.clear()
	for i in range(args[1]):
		l.append([args[0][i][0],args[0][i][1],args[0][i][2],args[0][i][3]])
	#print(l)
		

func cbDrawFaceLandmark(args):
	flen = args[1]
	f.clear()
	for i in range(args[1]):
		f.append([args[0][i][0],args[0][i][1],args[0][i][2],args[0][i][3]])
	#print(f)
	

func pos(x,y,z):
	var rpos = Vector3((x*space.size.x)+(space.position.x-space.size.x/2),((1-y)*space.size.y)-(space.position.y+space.size.y/2),3)
	rpos = Vector3(rd(rpos.x),rd(rpos.y),rd(rpos.z))
	return rpos
	
func rd(v):
	return snappedf(v,0.001)

func _init():
	if OS.has_feature('web'):
		console.log("Console:Hello my HTML page")
		print("Print:Hello my HTML page ")
		for i in range(llen):
			l.append([0.,0.,0.,0.])
		for i in range(rlen):
			r.append([0.,0.,0.,0.])
		for i in range(plen):
			p.append([0.,0.,0.,0.])
		for i in range(flen):
			f.append([0.,0.,0.,0.])

func _ready():
	if OS.has_feature('web'):
		#here we should callbacks for mediapipe func
		externalator.addGodotFunction('cbDrawPoseLandmark',_js_cb_draw_pose_landmark)
		externalator.addGodotFunction('cbDrawLeftHandLandmark',_js_cb_draw_left_hand_landmark)
		externalator.addGodotFunction('cbDrawRightHandLandmark',_js_cb_draw_right_hand_landmark)
		externalator.addGodotFunction('cbDrawFaceLandmark',_js_cb_draw_face_landmark)
		# Third argument is optional userdata, it can be any variable.
		console.log("-Ready-")
		
		for i in range(1):
			var poly = CSGPolygon3D.new()
			var path = Path3D.new()
			var curve = Curve3D.new()
			space.add_child(path)
			space.add_child(poly)
			poly.polygon=PackedVector2Array([Vector2(0, 0), Vector2(0, 0.2), Vector2(0.2, 0.2), Vector2(0.2, 0)])
			poly.mode=CSGPolygon3D.MODE_PATH
			poly.path_node=path.get_path()
			path.curve = curve
			
			path.curve.add_point(pos(0.0,0.0,0))
			path.curve.add_point(pos(1.0,1.0,0))
			
			linelist.append(path)

	else:
		for i in range(1):
			var poly = CSGPolygon3D.new()
			var path = Path3D.new()
			var curve = Curve3D.new()
			space.add_child(path)
			space.add_child(poly)
			poly.polygon=PackedVector2Array([Vector2(0, 0), Vector2(0, 0.2), Vector2(0.2, 0.2), Vector2(0.2, 0)])
			poly.mode=CSGPolygon3D.MODE_PATH
			poly.path_node=path.get_path()
			path.curve = curve
			
			path.curve.add_point(pos(0.0,0.0,0))
			path.curve.add_point(pos(1.0,1.0,0))
			
			linelist.append(path)
	
func _process(delta):
	if OS.has_feature('web'):
		$Screen/screenres.text=str(DisplayServer.window_get_size())
		const X=0
		const Y=1
		const Z=2
		
		label_p11.text = "p11: "+str(rd(p[11][X]))+" "+str(rd(p[11][Y]))+" "+str(rd(p[11][Z]))
		label_p12.text = "p12: "+str(rd(p[12][X]))+" "+str(rd(p[12][Y]))+" "+str(rd(p[12][Z]))
		

		linelist[0].curve.set_point_position(1,pos(rd(p[11][X]),rd(p[11][Y]),rd(p[11][Z])))
		linelist[0].curve.set_point_position(0,pos(rd(p[12][X]),rd(p[12][Y]),rd(p[11][Z])))
		print(linelist[0].curve.get_point_tilt(1)," ",linelist[0].curve.get_point_tilt(0))
		
		"
func draw2dlines():
	const X=0
	const Y=1
	const Z=2
	
	linelist[0].set_point_position(0,pos(rd(p[11][X]),rd(p[11][Y])))
	linelist[0].set_point_position(1,pos(rd(p[12][X]),rd(p[12][Y])))
	linelist[1].set_point_position(0,pos(rd(p[11][X]),rd(p[11][Y])))
	linelist[1].set_point_position(1,pos(rd(p[13][X]),rd(p[13][Y])))
	linelist[2].set_point_position(0,pos(rd(p[12][X]),rd(p[12][Y])))
	linelist[2].set_point_position(1,pos(rd(p[14][X]),rd(p[14][Y])))
	linelist[3].set_point_position(0,pos(rd(p[13][X]),rd(p[13][Y])))
	linelist[3].set_point_position(1,pos(rd(l[0][X]),rd(l[0][Y])))
	linelist[4].set_point_position(0,pos(rd(p[14][X]),rd(p[14][Y])))
	linelist[4].set_point_position(1,pos(rd(r[0][X]),rd(r[0][Y])))
	linelist[5].set_point_position(0,pos(rd(p[11][X]),rd(p[11][Y])))
	linelist[5].set_point_position(1,pos(rd(p[23][X]),rd(p[23][Y])))
	linelist[6].set_point_position(0,pos(rd(p[12][X]),rd(p[12][Y])))
	linelist[6].set_point_position(1,pos(rd(p[24][X]),rd(p[24][Y])))
	linelist[7].set_point_position(0,pos(rd(p[23][X]),rd(p[23][Y])))
	linelist[7].set_point_position(1,pos(rd(p[24][X]),rd(p[24][Y])))
	
	### RIGHT HAND
	## FINGER 1
	linelist[8].set_point_position(0,pos(rd(r[0][X]),rd(r[0][Y])))
	linelist[8].set_point_position(1,pos(rd(r[1][X]),rd(r[1][Y])))
	linelist[9].set_point_position(0,pos(rd(r[1][X]),rd(r[1][Y])))
	linelist[9].set_point_position(1,pos(rd(r[2][X]),rd(r[2][Y])))
	linelist[10].set_point_position(0,pos(rd(r[2][X]),rd(r[2][Y])))
	linelist[10].set_point_position(1,pos(rd(r[3][X]),rd(r[3][Y])))
	linelist[11].set_point_position(0,pos(rd(r[3][X]),rd(r[3][Y])))
	linelist[11].set_point_position(1,pos(rd(r[4][X]),rd(r[4][Y])))
	## FINGER 2
	linelist[12].set_point_position(0,pos(rd(r[0][X]),rd(r[0][Y])))
	linelist[12].set_point_position(1,pos(rd(r[5][X]),rd(r[5][Y])))
	linelist[13].set_point_position(0,pos(rd(r[5][X]),rd(r[5][Y])))
	linelist[13].set_point_position(1,pos(rd(r[6][X]),rd(r[6][Y])))
	linelist[14].set_point_position(0,pos(rd(r[6][X]),rd(r[6][Y])))
	linelist[14].set_point_position(1,pos(rd(r[7][X]),rd(r[7][Y])))
	linelist[15].set_point_position(0,pos(rd(r[7][X]),rd(r[7][Y])))
	linelist[15].set_point_position(1,pos(rd(r[8][X]),rd(r[8][Y])))
	## FINGER 3
	linelist[16].set_point_position(0,pos(rd(r[5][X]),rd(r[5][Y])))
	linelist[16].set_point_position(1,pos(rd(r[9][X]),rd(r[9][Y])))
	linelist[17].set_point_position(0,pos(rd(r[9][X]),rd(r[9][Y])))
	linelist[17].set_point_position(1,pos(rd(r[10][X]),rd(r[10][Y])))
	linelist[18].set_point_position(0,pos(rd(r[10][X]),rd(r[10][Y])))
	linelist[18].set_point_position(1,pos(rd(r[11][X]),rd(r[11][Y])))
	linelist[19].set_point_position(0,pos(rd(r[11][X]),rd(r[11][Y])))
	linelist[19].set_point_position(1,pos(rd(r[12][X]),rd(r[12][Y])))
	## FINGER 4
	linelist[20].set_point_position(0,pos(rd(r[9][X]),rd(r[9][Y])))
	linelist[20].set_point_position(1,pos(rd(r[13][X]),rd(r[13][Y])))
	linelist[21].set_point_position(0,pos(rd(r[13][X]),rd(r[13][Y])))
	linelist[21].set_point_position(1,pos(rd(r[14][X]),rd(r[14][Y])))
	linelist[22].set_point_position(0,pos(rd(r[14][X]),rd(r[14][Y])))
	linelist[22].set_point_position(1,pos(rd(r[15][X]),rd(r[15][Y])))
	linelist[23].set_point_position(0,pos(rd(r[15][X]),rd(r[15][Y])))
	linelist[23].set_point_position(1,pos(rd(r[16][X]),rd(r[16][Y])))
	## FINGER 5
	linelist[24].set_point_position(0,pos(rd(r[13][X]),rd(r[13][Y])))
	linelist[24].set_point_position(1,pos(rd(r[17][X]),rd(r[17][Y])))
	linelist[25].set_point_position(0,pos(rd(r[17][X]),rd(r[17][Y])))
	linelist[25].set_point_position(1,pos(rd(r[18][X]),rd(r[18][Y])))
	linelist[26].set_point_position(0,pos(rd(r[18][X]),rd(r[18][Y])))
	linelist[26].set_point_position(1,pos(rd(r[19][X]),rd(r[19][Y])))
	linelist[27].set_point_position(0,pos(rd(r[19][X]),rd(r[19][Y])))
	linelist[27].set_point_position(1,pos(rd(r[20][X]),rd(r[20][Y])))
	linelist[28].set_point_position(0,pos(rd(r[17][X]),rd(r[17][Y])))
	linelist[28].set_point_position(1,pos(rd(r[0][X]),rd(r[0][Y])))

	### LEFT HAND
	## FINGER 1
	linelist[29].set_point_position(0,pos(rd(l[0][X]),rd(l[0][Y])))
	linelist[29].set_point_position(1,pos(rd(l[1][X]),rd(l[1][Y])))
	linelist[30].set_point_position(0,pos(rd(l[1][X]),rd(l[1][Y])))
	linelist[30].set_point_position(1,pos(rd(l[2][X]),rd(l[2][Y])))
	linelist[31].set_point_position(0,pos(rd(l[2][X]),rd(l[2][Y])))
	linelist[31].set_point_position(1,pos(rd(l[3][X]),rd(l[3][Y])))
	linelist[32].set_point_position(0,pos(rd(l[3][X]),rd(l[3][Y])))
	linelist[32].set_point_position(1,pos(rd(l[4][X]),rd(l[4][Y])))
	## FINGER 2
	linelist[34].set_point_position(0,pos(rd(l[0][X]),rd(l[0][Y])))
	linelist[34].set_point_position(1,pos(rd(l[5][X]),rd(l[5][Y])))
	linelist[35].set_point_position(0,pos(rd(l[5][X]),rd(l[5][Y])))
	linelist[35].set_point_position(1,pos(rd(l[6][X]),rd(l[6][Y])))
	linelist[36].set_point_position(0,pos(rd(l[6][X]),rd(l[6][Y])))
	linelist[36].set_point_position(1,pos(rd(l[7][X]),rd(l[7][Y])))
	linelist[37].set_point_position(0,pos(rd(l[7][X]),rd(l[7][Y])))
	linelist[37].set_point_position(1,pos(rd(l[8][X]),rd(l[8][Y])))
	## FINGER 3
	linelist[38].set_point_position(0,pos(rd(l[5][X]),rd(l[5][Y])))
	linelist[38].set_point_position(1,pos(rd(l[9][X]),rd(l[9][Y])))
	linelist[39].set_point_position(0,pos(rd(l[9][X]),rd(l[9][Y])))
	linelist[39].set_point_position(1,pos(rd(l[10][X]),rd(l[10][Y])))
	linelist[40].set_point_position(0,pos(rd(l[10][X]),rd(l[10][Y])))
	linelist[40].set_point_position(1,pos(rd(l[11][X]),rd(l[11][Y])))
	linelist[41].set_point_position(0,pos(rd(l[11][X]),rd(l[11][Y])))
	linelist[41].set_point_position(1,pos(rd(l[12][X]),rd(l[12][Y])))
	## FINGER 4
	linelist[42].set_point_position(0,pos(rd(l[9][X]),rd(l[9][Y])))
	linelist[42].set_point_position(1,pos(rd(l[13][X]),rd(l[13][Y])))
	linelist[43].set_point_position(0,pos(rd(l[13][X]),rd(l[13][Y])))
	linelist[43].set_point_position(1,pos(rd(l[14][X]),rd(l[14][Y])))
	linelist[44].set_point_position(0,pos(rd(l[14][X]),rd(l[14][Y])))
	linelist[44].set_point_position(1,pos(rd(l[15][X]),rd(l[15][Y])))
	linelist[45].set_point_position(0,pos(rd(l[15][X]),rd(l[15][Y])))
	linelist[45].set_point_position(1,pos(rd(l[16][X]),rd(l[16][Y])))
	## FINGER 5
	linelist[46].set_point_position(0,pos(rd(l[13][X]),rd(l[13][Y])))
	linelist[46].set_point_position(1,pos(rd(l[17][X]),rd(l[17][Y])))
	linelist[47].set_point_position(0,pos(rd(l[17][X]),rd(l[17][Y])))
	linelist[47].set_point_position(1,pos(rd(l[18][X]),rd(l[18][Y])))
	linelist[48].set_point_position(0,pos(rd(l[18][X]),rd(l[18][Y])))
	linelist[48].set_point_position(1,pos(rd(l[19][X]),rd(l[19][Y])))
	linelist[49].set_point_position(0,pos(rd(l[19][X]),rd(l[19][Y])))
	linelist[49].set_point_position(1,pos(rd(l[20][X]),rd(l[20][Y])))
	linelist[50].set_point_position(0,pos(rd(l[17][X]),rd(l[17][Y])))
	linelist[50].set_point_position(1,pos(rd(l[0][X]),rd(l[0][Y])))
	
	### FACE
	## STROKE
	linelist[51].set_point_position(0,pos(rd(f[152][X]),rd(f[152][Y])))
	linelist[51].set_point_position(1,pos(rd(f[150][X]),rd(f[150][Y])))
	linelist[52].set_point_position(0,pos(rd(f[150][X]),rd(f[150][Y])))
	linelist[52].set_point_position(1,pos(rd(f[127][X]),rd(f[127][Y])))
	linelist[53].set_point_position(0,pos(rd(f[127][X]),rd(f[127][Y])))
	linelist[53].set_point_position(1,pos(rd(f[10][X]),rd(f[10][Y])))
	linelist[54].set_point_position(0,pos(rd(f[10][X]),rd(f[10][Y])))
	linelist[54].set_point_position(1,pos(rd(f[356][X]),rd(f[356][Y])))
	linelist[55].set_point_position(0,pos(rd(f[356][X]),rd(f[356][Y])))
	linelist[55].set_point_position(1,pos(rd(f[379][X]),rd(f[379][Y])))
	linelist[56].set_point_position(0,pos(rd(f[379][X]),rd(f[379][Y])))
	linelist[56].set_point_position(1,pos(rd(f[152][X]),rd(f[152][Y])))
	
	## LIPS
	linelist[57].width = 2
	linelist[58].width = 2
	linelist[59].width = 2
	linelist[60].width = 2
	linelist[57].set_point_position(0,pos(rd(f[78][X]),rd(f[78][Y])))
	linelist[57].set_point_position(1,pos(rd(f[13][X]),rd(f[13][Y])))
	linelist[58].set_point_position(0,pos(rd(f[13][X]),rd(f[13][Y])))
	linelist[58].set_point_position(1,pos(rd(f[308][X]),rd(f[308][Y])))
	linelist[59].set_point_position(0,pos(rd(f[308][X]),rd(f[308][Y])))
	linelist[59].set_point_position(1,pos(rd(f[14][X]),rd(f[14][Y])))
	linelist[60].set_point_position(0,pos(rd(f[14][X]),rd(f[14][Y])))
	linelist[60].set_point_position(1,pos(rd(f[78][X]),rd(f[78][Y])))
	
	## RIGHT EYE
	linelist[61].width = 2
	linelist[62].width = 2
	linelist[63].width = 2
	linelist[64].width = 2
	linelist[61].set_point_position(0,pos(rd(f[33][X]),rd(f[33][Y])))
	linelist[61].set_point_position(1,pos(rd(f[159][X]),rd(f[159][Y])))
	linelist[62].set_point_position(0,pos(rd(f[159][X]),rd(f[159][Y])))
	linelist[62].set_point_position(1,pos(rd(f[133][X]),rd(f[133][Y])))
	linelist[63].set_point_position(0,pos(rd(f[133][X]),rd(f[133][Y])))
	linelist[63].set_point_position(1,pos(rd(f[145][X]),rd(f[145][Y])))
	linelist[64].set_point_position(0,pos(rd(f[145][X]),rd(f[145][Y])))
	linelist[64].set_point_position(1,pos(rd(f[33][X]),rd(f[33][Y])))
	
	## LEFT EYE
	linelist[65].width = 2
	linelist[66].width = 2
	linelist[67].width = 2
	linelist[68].width = 2
	linelist[65].set_point_position(0,pos(rd(f[362][X]),rd(f[362][Y])))
	linelist[65].set_point_position(1,pos(rd(f[386][X]),rd(f[386][Y])))
	linelist[66].set_point_position(0,pos(rd(f[386][X]),rd(f[386][Y])))
	linelist[66].set_point_position(1,pos(rd(f[263][X]),rd(f[263][Y])))
	linelist[67].set_point_position(0,pos(rd(f[263][X]),rd(f[263][Y])))
	linelist[67].set_point_position(1,pos(rd(f[374][X]),rd(f[374][Y])))
	linelist[68].set_point_position(0,pos(rd(f[374][X]),rd(f[374][Y])))
	linelist[68].set_point_position(1,pos(rd(f[362][X]),rd(f[362][Y])))
	
	## NOSE
	linelist[69].set_point_position(0,pos(rd(f[4][X]),rd(f[4][Y])))
	linelist[69].set_point_position(1,pos(rd(f[6][X]),rd(f[6][Y])))
"
