extends Node2D


@export var bat_scene: PackedScene

@onready var spawn_points = $SpawnPoints.get_children()
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var final_score_label: Label = $CanvasLayer/FinalScoreLabel
@onready var game_over_label: Label = $CanvasLayer/GameOverLabel
@onready var time_label: Label = $CanvasLayer/TimeLabel
@onready var final_time_label: Label = $CanvasLayer/FinalTimeLabel

var time_survived = 0.0
var bats_per_wave = 1
var score = 0
func spawn_bat():
	if get_tree().get_nodes_in_group("bat_enemy").size() >= 30:
		return


	var bat = bat_scene.instantiate()

	var point = spawn_points.pick_random()
	
	var offset = Vector2(
		randf_range(-10,10),randf_range(-10,10))

	bat.global_position = point.global_position + offset
	add_child(bat)
	
func _on_timer_timeout():

	for i in range(bats_per_wave):

		spawn_bat()

	bats_per_wave += 1
func add_score():
	score += 1
	score_label.text = "Score:" + str(score)

func _process(delta):
	time_survived += delta
	var minutes = int(time_survived) / 60
	var seconds = int(time_survived) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func game_over():
	game_over_label.show()
	final_score_label.text = "Kills:" + str(score) 
	score_label.hide()
	final_score_label.show()
	var minutes = int(time_survived) / 60
	var seconds = int(time_survived) % 60
	final_time_label.text = "Time Survived:%02d:%02d" % [minutes,seconds]
	final_time_label.show()
	get_tree().paused = true
