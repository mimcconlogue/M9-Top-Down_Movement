class_name Runner
extends CharacterBody2D
signal walked_to

@onready var _finish_line: FinishLine = %FinishLine
@onready var _runner_visual: RunnerVisual = %RunnerVisualRed
@export var max_speed = 1200
@export var acceleration := 1400
@export var deceleration := 1600
@onready var dust: GPUParticles2D = $Dust


func walk_to(destination_global_position: Vector2) -> void:
	var direction := global_position.direction_to(destination_global_position)
	_runner_visual.angle = direction.orthogonal().angle()
	_runner_visual.animation_name = RunnerVisual.Animations.WALK
	dust.emitting = true
	var distance := global_position.distance_to(destination_global_position)
	var duration  = distance / (max_speed * 0.2)
	var tween := create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func():
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		dust.emitting = false
		walked_to.emit()
	)
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity = direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
	if velocity.length() > 0 :
		_runner_visual.angle = rotate_toward(_runner_visual.angle,direction.orthogonal().angle(), 8 * delta)
		_runner_visual.animation_name = RunnerVisual.Animations.WALK
		var current_speed_percent = velocity.length() / max_speed
		
		if current_speed_percent > 0.6:
			_runner_visual.animation_name = RunnerVisual.Animations.RUN
			dust.emitting = true
		else:
			dust.emitting = false
	
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
