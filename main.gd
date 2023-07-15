extends Node
# just an example, print is already send outputs to web consolle 

@onready var label_p12 = $Screen/ColorRect/VBoxContainer/label_p12
@onready var label_p11 = $Screen/ColorRect/VBoxContainer/label_p11
@onready var window = $Screen/window

var console = JavaScriptBridge.get_interface("console")

var externalator = JavaScriptBridge.get_interface("externalator")
var _js_cb_draw_pose_landmark = JavaScriptBridge.create_callback(cbDrawPoseLandmark)
var _js_cb_draw_left_hand_landmark = JavaScriptBridge.create_callback(cbDrawLeftHandLandmark)
var _js_cb_draw_right_hand_landmark = JavaScriptBridge.create_callback(cbDrawRightHandLandmark)

#var linesLeftHand:Array
var l=[[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.]]
var llen=21

#var linesRightHand:Array
var r=[[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.]]
var rlen=21

#var linesPose:Array
var p=[[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],#7
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],#14
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],#21
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],#28
	[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.],[0.,0.,0.,0.]]#33
var plen=33

var linelist = []

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

func pos(x,y):
	var rpos = Vector2(x*window.size.x,(y)*window.size.y)
	print(rpos)
	return rpos

func _init():
	if OS.has_feature('web'):
		console.log("Console:Hello my HTML page")
		print("Print:Hello my HTML page ")

func _ready():
	if OS.has_feature('web'):
		#here we should callbacks for mediapipe func
		externalator.addGodotFunction('cbDrawPoseLandmark',_js_cb_draw_pose_landmark)
		externalator.addGodotFunction('cbDrawLeftHandLandmark',_js_cb_draw_left_hand_landmark)
		externalator.addGodotFunction('cbDrawRightHandLandmark',_js_cb_draw_right_hand_landmark)
		# Third argument is optional userdata, it can be any variable.
		console.log("-Ready-")
		
		for i in range(69):
			var line = Line2D.new() # Create a new Sprite2D.
			line.width=5
			line.add_point(pos(0,0))
			line.add_point(pos(0,0))
			window.add_child(line) # Add it as a child of this node.
			linelist.append(line)

	else:
		$Screen.visible=false
		$Label.text="WORKS ONLY FOR WEB"
	
func _process(delta):
	$Screen/screenres.text=str(DisplayServer.window_get_size())
	const X=0
	const Y=1
	const Z=2
	const V=3
	label_p11.text = "p11: "+str(snappedf(p[11][X],0.01))+" "+str(snappedf(p[11][Y],0.01))+" "+str(snappedf(p[11][Z],0.01))+" "+str(snappedf(p[11][V],0.01))
	label_p12.text = "p12: "+str(snappedf(p[12][X],0.01))+" "+str(snappedf(p[12][Y],0.01))+" "+str(snappedf(p[12][Z],0.01))+" "+str(snappedf(p[12][V],0.01))
	
	#0-6 head
	
	linelist[0].set_point_position(0,pos(snappedf(p[11][X],0.01),snappedf(p[11][Y],0.01)))
	linelist[0].set_point_position(1,pos(snappedf(p[12][X],0.01),snappedf(p[12][Y],0.01)))
	linelist[1].set_point_position(0,pos(snappedf(p[11][X],0.01),snappedf(p[11][Y],0.01)))
	linelist[1].set_point_position(1,pos(snappedf(p[13][X],0.01),snappedf(p[13][Y],0.01)))
	linelist[2].set_point_position(0,pos(snappedf(p[12][X],0.01),snappedf(p[12][Y],0.01)))
	linelist[2].set_point_position(1,pos(snappedf(p[14][X],0.01),snappedf(p[14][Y],0.01)))
	linelist[3].set_point_position(0,pos(snappedf(p[13][X],0.01),snappedf(p[13][Y],0.01)))
	linelist[3].set_point_position(1,pos(snappedf(l[0][X],0.01),snappedf(l[0][Y],0.01)))
	linelist[4].set_point_position(0,pos(snappedf(p[14][X],0.01),snappedf(p[14][Y],0.01)))
	linelist[4].set_point_position(1,pos(snappedf(r[0][X],0.01),snappedf(r[0][Y],0.01)))
	linelist[5].set_point_position(0,pos(snappedf(p[11][X],0.01),snappedf(p[11][Y],0.01)))
	linelist[5].set_point_position(1,pos(snappedf(p[23][X],0.01),snappedf(p[23][Y],0.01)))
	linelist[6].set_point_position(0,pos(snappedf(p[12][X],0.01),snappedf(p[12][Y],0.01)))
	linelist[6].set_point_position(1,pos(snappedf(p[24][X],0.01),snappedf(p[24][Y],0.01)))
	linelist[7].set_point_position(0,pos(snappedf(p[23][X],0.01),snappedf(p[23][Y],0.01)))
	linelist[7].set_point_position(1,pos(snappedf(p[24][X],0.01),snappedf(p[24][Y],0.01)))
	
	
	### RIGHT HAND
	## FINGER 1
	linelist[8].set_point_position(0,pos(snappedf(r[0][X],0.01),snappedf(r[0][Y],0.01)))
	linelist[8].set_point_position(1,pos(snappedf(r[1][X],0.01),snappedf(r[1][Y],0.01)))
	linelist[9].set_point_position(0,pos(snappedf(r[1][X],0.01),snappedf(r[1][Y],0.01)))
	linelist[9].set_point_position(1,pos(snappedf(r[2][X],0.01),snappedf(r[2][Y],0.01)))
	linelist[10].set_point_position(0,pos(snappedf(r[2][X],0.01),snappedf(r[2][Y],0.01)))
	linelist[10].set_point_position(1,pos(snappedf(r[3][X],0.01),snappedf(r[3][Y],0.01)))
	linelist[11].set_point_position(0,pos(snappedf(r[3][X],0.01),snappedf(r[3][Y],0.01)))
	linelist[11].set_point_position(1,pos(snappedf(r[4][X],0.01),snappedf(r[4][Y],0.01)))
	## FINGER 2
	linelist[12].set_point_position(0,pos(snappedf(r[0][X],0.01),snappedf(r[0][Y],0.01)))
	linelist[12].set_point_position(1,pos(snappedf(r[5][X],0.01),snappedf(r[5][Y],0.01)))
	linelist[13].set_point_position(0,pos(snappedf(r[5][X],0.01),snappedf(r[5][Y],0.01)))
	linelist[13].set_point_position(1,pos(snappedf(r[6][X],0.01),snappedf(r[6][Y],0.01)))
	linelist[14].set_point_position(0,pos(snappedf(r[6][X],0.01),snappedf(r[6][Y],0.01)))
	linelist[14].set_point_position(1,pos(snappedf(r[7][X],0.01),snappedf(r[7][Y],0.01)))
	linelist[15].set_point_position(0,pos(snappedf(r[7][X],0.01),snappedf(r[7][Y],0.01)))
	linelist[15].set_point_position(1,pos(snappedf(r[8][X],0.01),snappedf(r[8][Y],0.01)))
	## FINGER 3
	linelist[16].set_point_position(0,pos(snappedf(r[5][X],0.01),snappedf(r[5][Y],0.01)))
	linelist[16].set_point_position(1,pos(snappedf(r[9][X],0.01),snappedf(r[9][Y],0.01)))
	linelist[17].set_point_position(0,pos(snappedf(r[9][X],0.01),snappedf(r[9][Y],0.01)))
	linelist[17].set_point_position(1,pos(snappedf(r[10][X],0.01),snappedf(r[10][Y],0.01)))
	linelist[18].set_point_position(0,pos(snappedf(r[10][X],0.01),snappedf(r[10][Y],0.01)))
	linelist[18].set_point_position(1,pos(snappedf(r[11][X],0.01),snappedf(r[11][Y],0.01)))
	linelist[19].set_point_position(0,pos(snappedf(r[11][X],0.01),snappedf(r[11][Y],0.01)))
	linelist[19].set_point_position(1,pos(snappedf(r[12][X],0.01),snappedf(r[12][Y],0.01)))
	## FINGER 4
	linelist[20].set_point_position(0,pos(snappedf(r[9][X],0.01),snappedf(r[9][Y],0.01)))
	linelist[20].set_point_position(1,pos(snappedf(r[13][X],0.01),snappedf(r[13][Y],0.01)))
	linelist[21].set_point_position(0,pos(snappedf(r[13][X],0.01),snappedf(r[13][Y],0.01)))
	linelist[21].set_point_position(1,pos(snappedf(r[14][X],0.01),snappedf(r[14][Y],0.01)))
	linelist[22].set_point_position(0,pos(snappedf(r[14][X],0.01),snappedf(r[14][Y],0.01)))
	linelist[22].set_point_position(1,pos(snappedf(r[15][X],0.01),snappedf(r[15][Y],0.01)))
	linelist[23].set_point_position(0,pos(snappedf(r[15][X],0.01),snappedf(r[15][Y],0.01)))
	linelist[23].set_point_position(1,pos(snappedf(r[16][X],0.01),snappedf(r[16][Y],0.01)))
	## FINGER 5
	linelist[24].set_point_position(0,pos(snappedf(r[13][X],0.01),snappedf(r[13][Y],0.01)))
	linelist[24].set_point_position(1,pos(snappedf(r[17][X],0.01),snappedf(r[17][Y],0.01)))
	linelist[25].set_point_position(0,pos(snappedf(r[17][X],0.01),snappedf(r[17][Y],0.01)))
	linelist[25].set_point_position(1,pos(snappedf(r[18][X],0.01),snappedf(r[18][Y],0.01)))
	linelist[26].set_point_position(0,pos(snappedf(r[18][X],0.01),snappedf(r[18][Y],0.01)))
	linelist[26].set_point_position(1,pos(snappedf(r[19][X],0.01),snappedf(r[19][Y],0.01)))
	linelist[27].set_point_position(0,pos(snappedf(r[19][X],0.01),snappedf(r[19][Y],0.01)))
	linelist[27].set_point_position(1,pos(snappedf(r[20][X],0.01),snappedf(r[20][Y],0.01)))
	linelist[28].set_point_position(0,pos(snappedf(r[17][X],0.01),snappedf(r[17][Y],0.01)))
	linelist[28].set_point_position(1,pos(snappedf(r[0][X],0.01),snappedf(r[0][Y],0.01)))
	
	
	
### LEFT HAND
	## FINGER 1
	linelist[29].set_point_position(0,pos(snappedf(l[0][X],0.01),snappedf(l[0][Y],0.01)))
	linelist[29].set_point_position(1,pos(snappedf(l[1][X],0.01),snappedf(l[1][Y],0.01)))
	linelist[30].set_point_position(0,pos(snappedf(l[1][X],0.01),snappedf(l[1][Y],0.01)))
	linelist[30].set_point_position(1,pos(snappedf(l[2][X],0.01),snappedf(l[2][Y],0.01)))
	linelist[31].set_point_position(0,pos(snappedf(l[2][X],0.01),snappedf(l[2][Y],0.01)))
	linelist[31].set_point_position(1,pos(snappedf(l[3][X],0.01),snappedf(l[3][Y],0.01)))
	linelist[32].set_point_position(0,pos(snappedf(l[3][X],0.01),snappedf(l[3][Y],0.01)))
	linelist[32].set_point_position(1,pos(snappedf(l[4][X],0.01),snappedf(l[4][Y],0.01)))
	## FINGER 2
	linelist[34].set_point_position(0,pos(snappedf(l[0][X],0.01),snappedf(l[0][Y],0.01)))
	linelist[34].set_point_position(1,pos(snappedf(l[5][X],0.01),snappedf(l[5][Y],0.01)))
	linelist[35].set_point_position(0,pos(snappedf(l[5][X],0.01),snappedf(l[5][Y],0.01)))
	linelist[35].set_point_position(1,pos(snappedf(l[6][X],0.01),snappedf(l[6][Y],0.01)))
	linelist[36].set_point_position(0,pos(snappedf(l[6][X],0.01),snappedf(l[6][Y],0.01)))
	linelist[36].set_point_position(1,pos(snappedf(l[7][X],0.01),snappedf(l[7][Y],0.01)))
	linelist[37].set_point_position(0,pos(snappedf(l[7][X],0.01),snappedf(l[7][Y],0.01)))
	linelist[37].set_point_position(1,pos(snappedf(l[8][X],0.01),snappedf(l[8][Y],0.01)))
	## FINGER 3
	linelist[38].set_point_position(0,pos(snappedf(l[5][X],0.01),snappedf(l[5][Y],0.01)))
	linelist[38].set_point_position(1,pos(snappedf(l[9][X],0.01),snappedf(l[9][Y],0.01)))
	linelist[39].set_point_position(0,pos(snappedf(l[9][X],0.01),snappedf(l[9][Y],0.01)))
	linelist[39].set_point_position(1,pos(snappedf(l[10][X],0.01),snappedf(l[10][Y],0.01)))
	linelist[40].set_point_position(0,pos(snappedf(l[10][X],0.01),snappedf(l[10][Y],0.01)))
	linelist[40].set_point_position(1,pos(snappedf(l[11][X],0.01),snappedf(l[11][Y],0.01)))
	linelist[41].set_point_position(0,pos(snappedf(l[11][X],0.01),snappedf(l[11][Y],0.01)))
	linelist[41].set_point_position(1,pos(snappedf(l[12][X],0.01),snappedf(l[12][Y],0.01)))
	## FINGER 4
	linelist[42].set_point_position(0,pos(snappedf(l[9][X],0.01),snappedf(l[9][Y],0.01)))
	linelist[42].set_point_position(1,pos(snappedf(l[13][X],0.01),snappedf(l[13][Y],0.01)))
	linelist[43].set_point_position(0,pos(snappedf(l[13][X],0.01),snappedf(l[13][Y],0.01)))
	linelist[43].set_point_position(1,pos(snappedf(l[14][X],0.01),snappedf(l[14][Y],0.01)))
	linelist[44].set_point_position(0,pos(snappedf(l[14][X],0.01),snappedf(l[14][Y],0.01)))
	linelist[44].set_point_position(1,pos(snappedf(l[15][X],0.01),snappedf(l[15][Y],0.01)))
	linelist[45].set_point_position(0,pos(snappedf(l[15][X],0.01),snappedf(l[15][Y],0.01)))
	linelist[45].set_point_position(1,pos(snappedf(l[16][X],0.01),snappedf(l[16][Y],0.01)))
	## FINGER 5
	linelist[46].set_point_position(0,pos(snappedf(l[13][X],0.01),snappedf(l[13][Y],0.01)))
	linelist[46].set_point_position(1,pos(snappedf(l[17][X],0.01),snappedf(l[17][Y],0.01)))
	linelist[47].set_point_position(0,pos(snappedf(l[17][X],0.01),snappedf(l[17][Y],0.01)))
	linelist[47].set_point_position(1,pos(snappedf(l[18][X],0.01),snappedf(l[18][Y],0.01)))
	linelist[48].set_point_position(0,pos(snappedf(l[18][X],0.01),snappedf(l[18][Y],0.01)))
	linelist[48].set_point_position(1,pos(snappedf(l[19][X],0.01),snappedf(l[19][Y],0.01)))
	linelist[49].set_point_position(0,pos(snappedf(l[19][X],0.01),snappedf(l[19][Y],0.01)))
	linelist[49].set_point_position(1,pos(snappedf(l[20][X],0.01),snappedf(l[20][Y],0.01)))
	linelist[50].set_point_position(0,pos(snappedf(l[17][X],0.01),snappedf(l[17][Y],0.01)))
	linelist[50].set_point_position(1,pos(snappedf(l[0][X],0.01),snappedf(l[0][Y],0.01)))
	
	
