extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

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
	#connect the mob to the score label to update the score upon squashing one
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
