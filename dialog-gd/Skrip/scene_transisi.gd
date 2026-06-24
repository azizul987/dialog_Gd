extends Node2D


@export_file("*.tscn") var next_scene_path: String
@export var transition_duration: float = 0.7
@export var hold_black_duration: float = 0.25

@onready var story_label: Label = $StoryLabel
@onready var fade_layer: CanvasLayer = $FadeLayer

var top_panel: ColorRect
var bottom_panel: ColorRect
var left_panel: ColorRect
var right_panel: ColorRect


func _ready() -> void:
	story_label.story_finished.connect(_on_story_finished)
	create_transition_panels()


func create_transition_panels() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size

	top_panel = create_black_panel()
	bottom_panel = create_black_panel()
	left_panel = create_black_panel()
	right_panel = create_black_panel()

	fade_layer.add_child(top_panel)
	fade_layer.add_child(bottom_panel)
	fade_layer.add_child(left_panel)
	fade_layer.add_child(right_panel)

	reset_panel_positions(viewport_size)


func create_black_panel() -> ColorRect:
	var panel := ColorRect.new()
	panel.color = Color.BLACK
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return panel


func reset_panel_positions(viewport_size: Vector2) -> void:
	var width := viewport_size.x
	var height := viewport_size.y

	top_panel.size = Vector2(width, height / 2.0)
	bottom_panel.size = Vector2(width, height / 2.0)
	left_panel.size = Vector2(width / 2.0, height)
	right_panel.size = Vector2(width / 2.0, height)

	top_panel.position = Vector2(0, -height / 2.0)
	bottom_panel.position = Vector2(0, height)
	left_panel.position = Vector2(-width / 2.0, 0)
	right_panel.position = Vector2(width, 0)


func _on_story_finished() -> void:
	await play_box_close_transition()

	if next_scene_path == "":
		push_warning("Scene tujuan belum diisi.")
		return

	get_tree().change_scene_to_file(next_scene_path)


func play_box_close_transition() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var width := viewport_size.x
	var height := viewport_size.y

	reset_panel_positions(viewport_size)

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		top_panel,
		"position",
		Vector2(0, 0),
		transition_duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		bottom_panel,
		"position",
		Vector2(0, height / 2.0),
		transition_duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		left_panel,
		"position",
		Vector2(0, 0),
		transition_duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		right_panel,
		"position",
		Vector2(width / 2.0, 0),
		transition_duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await tween.finished
	await get_tree().create_timer(hold_black_duration).timeout
