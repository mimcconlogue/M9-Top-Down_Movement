extends Node2D

@onready var finish_line: FinishLine = $FinishLine
@onready var _count_down: CountDown = $CanvasLayer/CountDown
@onready var _runner: Runner = $Runner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finish_line.body_entered.connect(func (body: Node) -> void:
		if body is not Runner:
			return
		var runner := body as Runner

		runner.set_physics_process(false)
		var destination_position := (
			finish_line.global_position
			+ Vector2(0, 64)
		)

		runner.walk_to(destination_position)
		runner.walked_to.connect(
			finish_line.pop_confettis
		)
	)

	finish_line.confettis_finished.connect(
		get_tree().reload_current_scene.call_deferred
	)
	_count_down.start_counting()
	_runner.set_physics_process(false)
	_count_down.counting_finished.connect(
		func() -> void:
			_runner.set_physics_process(true)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
