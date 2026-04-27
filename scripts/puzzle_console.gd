extends Popup

@onready var text_edit: TextEdit = $Panel/TextEdit
@onready var run_button: Button = $Panel/RunButton
@onready var close_button: Button = $Panel/CloseButton

var expected_snippet: String = ""
var success_action: Callable = Callable()

func setup(start_code: String, expected: String, on_success: Callable) -> void:
	expected_snippet = expected
	success_action = on_success
	call_deferred("_set_text", start_code)
	Global.input_blocked = true
	popup_centered(Vector2(640, 360))
	call_deferred("_grab_focus")

func _set_text(code: String) -> void:
	text_edit.text = code

func _grab_focus() -> void:
	text_edit.grab_focus()

func _ready() -> void:
	run_button.pressed.connect(_on_run)
	close_button.pressed.connect(_on_close)
	visibility_changed.connect(_on_hidden)

func _on_run() -> void:
	if expected_snippet in text_edit.text:
		success_action.call()
		_on_close()
	else:
		text_edit.text += "\n# Ошибка: измени на " + expected_snippet

func _on_close() -> void:
	Global.input_blocked = false
	hide()
	queue_free()

func _on_hidden() -> void:
	Global.input_blocked = false
