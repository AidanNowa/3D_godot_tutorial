extends Node

@export var mob_scene: PackedScene


func _on_mob_timer_timeout():
	#create a new instance of the mob
	var mob = mob_scene.instantiate()
	
	#choose random location on spawnpath
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	#add random offset
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	#spawn the mob by adding it to the main scene
	add_child(mob)

