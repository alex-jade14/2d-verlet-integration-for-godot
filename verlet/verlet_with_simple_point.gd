extends Node2D

var points: Array[Dictionary] = [];
var bounce: float = 1
var gravity: float = 0.5
var friction: float = 0.999
var points_to_add: Array[Dictionary] = []

func _ready():
	points.append({
		"x": 100,
		"y": 100,
		"oldx": 95,
		"oldy": 95
	})


func _physics_process(delta: float) -> void:
	self.update_points()
	self.render_points()


func update_points() -> void:
	for i in points.size():
		var p: Dictionary = points[i]
		var vx: float = (p.x - p.oldx) * friction
		var vy: float = (p.y - p.oldy) * friction
		
		p.oldx = p.x
		p.oldy = p.y
		p.x += vx
		p.y += vy
		p.y += gravity
		
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

func render_points() -> void:
	points_to_add.clear()
	for i in points.size():
		points_to_add.append(points[i])
		queue_redraw()

func _draw() -> void:
	for i in points_to_add.size():
		draw_circle(Vector2(points_to_add[i].x, points_to_add[i].y), 10, Color.WHITE)
