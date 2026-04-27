
extends CanvasModulate

func _ready() -> void:
	color = Color(0.389, 0.389, 0.389, 1.0)

func remove_darkness() -> void:
	print("Darkness removal started")
	var tween = create_tween()
	tween.tween_property(self, "color", Color(1, 1, 1, 1), 0.5)
	await tween.finished
	queue_free()
