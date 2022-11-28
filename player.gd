extends CharacterBody2D

var health = 100
var speed = 300.0
var bullet_speed = 900.0
var bullet = preload("res://bullet.tscn")

var num_enemies_colliding = 0
var enemy_damage = 1

func _physics_process(delta):
	handle_move()
	handle_point()
	move_and_slide()

func handle_move(): 
	var directionY = Input.get_axis("ui_up", "ui_down")
	if directionY:
#        Move towards mouse
		velocity = global_position.direction_to(get_global_mouse_position()) * speed
	else:
		velocity = Vector2()
	
	if Input.is_action_just_pressed("LMB"):
		fire();

func handle_point():
	look_at(get_global_mouse_position())

func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = get_global_position();
	bullet_instance.rotation = deg_to_rad(rotation);
	bullet_instance.apply_central_impulse(Vector2(bullet_speed, 0).rotated(rotation));

	get_tree().get_root().call_deferred("add_child", bullet_instance);

func handle_incoming_damage():
	if num_enemies_colliding > 0:
		health -= enemy_damage * num_enemies_colliding

func _on_area_2d_body_entered(body):
	print('body entered: ', body.name)
	if body.name == 'Enemy':
		num_enemies_colliding += 1;


func _on_area_2d_body_exited(body):
	print('body exited: ', body.name)
	if body.name == 'Enemy':
		num_enemies_colliding -= 1;
