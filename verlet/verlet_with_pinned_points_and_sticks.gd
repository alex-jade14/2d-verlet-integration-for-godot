extends Node2D

var points: Array[Dictionary] = []
var sticks: Array[Dictionary] = []
var bounce: float = 1
var gravity: float = 0.5
var friction: float = 0.999
var angle: float = 0
var speed: float = 0.1
var points_to_add: Array[Dictionary] = []
var sticks_to_add: Array[Dictionary] = []


func _ready() -> void:
	points.append({
		"x": 100,
		"y": 50,
		"oldx": 85,
		"oldy": 45,
		"pinned": false
	})
	points.append({
		"x": 150,
		"y": 50,
		"oldx": 150,
		"oldy": 50,
		"pinned": false
	})
	points.append({
		"x": 150,
		"y": 100,
		"oldx": 150,
		"oldy": 100,
		"pinned": false
	})
	points.append({
		"x": 100,
		"y": 100,
		"oldx": 100,
		"oldy": 100,
		"pinned": false
	})
	points.append({
		"x": 550,
		"y": 100,
		"oldx": 550,
		"oldy": 100,
		"pinned": true
	})
	points.append({
		"x": 400,
		"y": 50,
		"oldx": 400,
		"oldy": 50,
		"pinned": false
	})
	points.append({
		"x": 250,
		"y": 50,
		"oldx": 250,
		"oldy": 50,
		"pinned": false
	})
	sticks.append({
		"p0": points[0],
		"p1": points[1],
		"length": calculate_distance(points[0], points[1]),
		"hidden": false
	})
	sticks.append({
		"p0": points[1],
		"p1": points[2],
		"length": calculate_distance(points[1], points[2]),
		"hidden": false
	})
	sticks.append({
		"p0": points[2],
		"p1": points[3],
		"length": calculate_distance(points[2], points[3]),
		"hidden": false
	})
	sticks.append({
		"p0": points[3],
		"p1": points[0],
		"length": calculate_distance(points[3], points[0]),
		"hidden": false
	})
	sticks.append({
		"p0": points[0],
		"p1": points[2],
		"length": calculate_distance(points[0], points[2]),
		"hidden": true
	})
	sticks.append({
		"p0": points[4],
		"p1": points[5],
		"length": calculate_distance(points[4], points[5]),
		"hidden": false
	})
	sticks.append({
		"p0": points[5],
		"p1": points[6],
		"length": calculate_distance(points[5], points[6]),
		"hidden": false
	})
	sticks.append({
		"p0": points[6],
		"p1": points[0],
		"length": calculate_distance(points[6], points[0]),
		"hidden": false
	})


func _physics_process(delta) -> void:
	self.update_points()
	for i in 3:
		self.update_sticks()
		self.constraint_points()
	self.render_points()
	self.render_sticks()


func update_points() -> void:
	for i in points.size():
		var p: Dictionary = points[i]
		if(not p.pinned):
			var vx: float = (p.x - p.oldx) * friction
			var vy: float = (p.y - p.oldy) * friction
			p.oldx = p.x
			p.oldy = p.y
			p.x += vx
			p.y += vy
			p.y += gravity
		

func constraint_points() -> void:
	for i in points.size():
		var p: Dictionary = points[i]
		if(not p.pinned):
			var vx: float = (p.x - p.oldx) * friction
			var vy: float = (p.y - p.oldy) * friction

			if(p.x > get_viewport().size.x):
				p.x = get_viewport().size.x
				p.oldx = p.x + vx * bounce
			elif(p.x < 0):
				p.x = 0
				p.oldx = p.x + vx * bounce

			if(p.y > get_viewport().size.y):
				p.y = get_viewport().size.y
				p.oldy = p.y + vy * bounce
			elif(p.y < 0):
				p.y = 0
				p.oldy = p.y + vy * bounce

func update_sticks() -> void:
	for i in sticks.size():
		var s: Dictionary = sticks[i]
		var dx: float = s.p1.x - s.p0.x
		var dy: float = s.p1.y - s.p0.y
		var distance: float = sqrt(dx * dx + dy * dy)
		var difference: float = s.length - distance
		var percent: float = difference / distance / 2
		var offsetX: float = dx * percent
		var offsetY: float = dy * percent
		
		if(not s.p0.pinned):
			s.p0.x -= offsetX
			s.p0.y -= offsetY
		if(not s.p1.pinned):
			s.p1.x += offsetX
			s.p1.y += offsetY

func render_points() -> void:
	points_to_add.clear()
	for i in points.size():
		points_to_add.append(points[i])
		queue_redraw()

func render_sticks() -> void:
	sticks_to_add.clear()
	for i in sticks.size():
		var s: Dictionary = sticks[i]
		if(not s.hidden == true):
			sticks_to_add.append(sticks[i])
			queue_redraw()
		

func _draw() -> void:
	for i in points_to_add.size():
		draw_circle(Vector2(points_to_add[i].x, points_to_add[i].y), 5, Color.WHITE)
	for i in sticks_to_add.size():
		draw_line(Vector2(sticks_to_add[i].p0.x, sticks_to_add[i].p0.y), Vector2(sticks_to_add[i].p1.x, sticks_to_add[i].p1.y), Color.WHITE)

func calculate_distance(p0, p1) -> float:
	var dx: float = p1.x - p0.x
	var dy: float = p1.y - p0.y
	return sqrt(dx * dx + dy * dy)
