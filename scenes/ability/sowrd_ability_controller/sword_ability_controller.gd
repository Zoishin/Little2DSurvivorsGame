extends Node

@export var max_range : float = 150

@export var sword_ability:PackedScene

var damage = 5
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy") as Array[Node2D] 
	
	enemies = enemies.filter(func(enemy : Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) <= pow(max_range, 2)
	)
	
	if enemies.size() == 0:
		return
		
	enemies.sort_custom(func(a : Node2D, b : Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance <= b_distance
	)	
	var sword_instance = sword_ability.instantiate() as Node2D
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4 
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return
		
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	$Timer.start()
	
