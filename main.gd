extends Node
# just an example, print is already send outputs to web consolle 

@onready var label_p12 = $Screen/ColorRect/VBoxContainer/label_p12
@onready var label_p11 = $Screen/ColorRect/VBoxContainer/label_p11
@onready var space = $"Evironment/3dbox"
@onready var environment = $Evironment

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

func cbDrawLeftHandLandmark(args):
	llen = args[1]
	l.clear()
	for i in range(args[1]):
		l.append([args[0][i][0],args[0][i][1],args[0][i][2],args[0][i][3]])

func cbDrawFaceLandmark(args):
	flen = args[1]
	f.clear()
	for i in range(args[1]):
		f.append([args[0][i][0],args[0][i][1],args[0][i][2],args[0][i][3]])

func pos(x,y,z):
	var rpos = Vector3((x*space.size.x)+(space.position.x-space.size.x/2),((1-y)*space.size.y)-(space.position.y+space.size.y/2),((1-z)*0.5)*5-(space.position.z+space.size.z/2))
	print(rpos.z)
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
		
		for i in range(69):
			var poly = CSGPolygon3D.new()
			var path = Path3D.new()
			var curve = Curve3D.new()
			var mat = StandardMaterial3D.new()
			environment.add_child(path)
			environment.add_child(poly)
			poly.polygon=PackedVector2Array([Vector2(0, 0), Vector2(0, 0.2), Vector2(0.2, 0.2), Vector2(0.2, 0)])
			#mat.albedo_color=Color(0.,1.,0.)
			poly.material=mat
			poly.material.albedo_color=Color(0.,1.,0.)
			poly.material.emission_enabled=true
			poly.material.emission=Color(0.,0.5,0.)

			poly.mode=CSGPolygon3D.MODE_PATH
			poly.path_rotation=CSGPolygon3D.PATH_ROTATION_PATH
			poly.path_node=path.get_path()
			path.curve = curve
			
			path.curve.add_point(pos(0.0,0.0,0))
			path.curve.add_point(pos(0.0,0.0,0))
			
			linelist.append(poly)
			#linelist.append(path)

	else:
		pass
			
			
	
func _process(delta):
	if OS.has_feature('web'):
		label_p11.text = "p11: "+str(rd(p[11][0]))+" "+str(rd(p[11][1]))+" "+str(rd(p[11][2]))
		label_p12.text = "p12: "+str(rd(p[12][0]))+" "+str(rd(p[12][1]))+" "+str(rd(p[12][2]))
		draw3dlines()
		
func update3dline(i,p1,p2,w=0.2):
	linelist[i].polygon=PackedVector2Array([Vector2(0, 0), Vector2(0, w), Vector2(w, w), Vector2(w, 0)])
	get_node(linelist[i].path_node).curve.set_point_position(0,pos(rd(p1[0]),rd(p1[1]),rd(p1[2])))
	get_node(linelist[i].path_node).curve.set_point_position(1,pos(rd(p2[0]),rd(p2[1]),rd(p2[2])))
	
func draw3dlines():
	### BODY
	update3dline(0,p[11],p[12])
	update3dline(1,p[11],p[13])
	update3dline(2,p[12],p[14])
	update3dline(3,p[13],l[0])
	update3dline(4,p[14],r[0])
	update3dline(5,p[11],p[23])
	update3dline(6,p[12],p[24])
	update3dline(7,p[23],p[24])
	
	### RIGHT HAND
	## FINGER 1
	update3dline(8,r[0],r[1],0.05)
	update3dline(9,r[1],r[2],0.05)
	update3dline(10,r[2],r[3],0.05)
	update3dline(11,r[3],r[4],0.05)
	## FINGER 2
	update3dline(12,r[0],r[5],0.05)
	update3dline(13,r[5],r[6],0.05)
	update3dline(14,r[6],r[7],0.05)
	update3dline(15,r[7],r[8],0.05)
	## FINGER 3
	update3dline(16,r[5],r[9],0.05)
	update3dline(17,r[9],r[10],0.05)
	update3dline(18,r[10],r[11],0.05)
	update3dline(19,r[11],r[12],0.05)
	## FINGER 4
	update3dline(20,r[9],r[13],0.05)
	update3dline(21,r[13],r[14],0.05)
	update3dline(22,r[14],r[15],0.05)
	update3dline(23,r[15],r[16],0.05)
	## FINGER 5
	update3dline(24,r[13],r[17],0.05)
	update3dline(25,r[17],r[18],0.05)
	update3dline(26,r[18],r[19],0.05)
	update3dline(27,r[19],r[20],0.05)
	update3dline(28,r[17],r[0],0.05)
	
	### LEFT HAND
	## FINGER 1
	update3dline(29,l[0],l[1],0.05)
	update3dline(30,l[1],l[2],0.05)
	update3dline(31,l[2],l[3],0.05)
	update3dline(32,l[3],l[4],0.05)
	## FINGER 2
	update3dline(33,l[0],l[5],0.05)
	update3dline(34,l[5],l[6],0.05)
	update3dline(35,l[6],l[7],0.05)
	update3dline(36,l[7],l[8],0.05)
	## FINGER 3
	update3dline(37,l[5],l[9],0.05)
	update3dline(38,l[9],l[10],0.05)
	update3dline(39,l[10],l[11],0.05)
	update3dline(40,l[11],l[12],0.05)
	## FINGER 4
	update3dline(41,l[9],l[13],0.05)
	update3dline(42,l[13],l[14],0.05)
	update3dline(43,l[14],l[15],0.05)
	update3dline(44,l[15],l[16],0.05)
	## FINGER 5
	update3dline(45,l[13],l[17],0.05)
	update3dline(46,l[17],l[18],0.05)
	update3dline(47,l[18],l[19],0.05)
	update3dline(48,l[19],l[20],0.05)
	update3dline(49,l[17],l[0],0.05)
	
	
	### FACE
	## STROKE
	update3dline(50,f[152],f[150],0.1)
	update3dline(51,f[150],f[127],0.1)
	update3dline(52,f[127],f[10],0.1)
	update3dline(53,f[10],f[356],0.1)
	update3dline(54,f[356],f[379],0.1)
	update3dline(55,f[379],f[152],0.1)
	## LIPS
	update3dline(56,f[78],f[13],0.05)
	update3dline(57,f[13],f[308],0.05)
	update3dline(58,f[308],f[14],0.05)
	update3dline(59,f[14],f[78],0.05)	
	## RIGHT EYE
	update3dline(60,f[33],f[159],0.05)
	update3dline(61,f[159],f[133],0.05)
	update3dline(62,f[133],f[145],0.05)
	update3dline(63,f[145],f[33],0.05)	
	## LEFT EYE
	update3dline(64,f[362],f[386],0.05)
	update3dline(65,f[386],f[263],0.05)
	update3dline(66,f[263],f[374],0.05)
	update3dline(67,f[374],f[362],0.05)	
	## NOSE
	update3dline(68,f[4],f[6],0.05)
