extends Node2D
@onready var popup := $Window
@onready var code_edit := popup.get_node_or_null("Camera2D/TextEdit")
const LOCKED_SIZE := Vector2(640, 360)
var run_button: Button
var reset_button: Button
var initial_code: String = ""

func _ready() -> void:
	_setup_popup()
	_find_buttons()
	_connect_signals()
	if code_edit:
		initial_code = code_edit.text
	popup.hide()

func _setup_popup() -> void:
	if popup is Control:
		popup.size = LOCKED_SIZE
		popup.min_size = LOCKED_SIZE

func _connect_signals() -> void:
	if run_button:
		run_button.pressed.connect(_on_run_pressed)
	if reset_button:
		reset_button.pressed.connect(_on_reset_pressed)
	if popup.has_signal("close_requested"):
		popup.close_requested.connect(_on_close_pressed)

func open_window() -> void:
	Global.input_blocked = true
	popup.show()
	if code_edit:
		code_edit.text = initial_code
		code_edit.grab_focus()

func _on_reset_pressed() -> void:
	if code_edit:
		code_edit.text = initial_code
		code_edit.grab_focus()

func _on_close_pressed() -> void:
	popup.hide()
	Global.input_blocked = false

func _on_run_pressed() -> void:
	if not code_edit:
		return
	if _check_code(code_edit.text):
		_extinguish_firewall()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Стена не погасла"

func _check_code(text: String) -> bool:
	var has_indexing: bool = false
	var has_function_call: bool = false
	
	var regex_function := RegEx.new()
	regex_function.compile("[a-zA-Z_][a-zA-Z0-9_]*\\([^)]*\\)")
	
	for line in text.split("\n"):
		var s := line.strip_edges().to_lower()
		
		if "[0]" in s or "[1]" in s or "[2]" in s:
			has_indexing = true
		
		if regex_function.search(line):
			has_function_call = true
	
	return has_indexing and has_function_call

func _extinguish_firewall() -> void:
	Global.firewall_extinguished = true
	
	var firewall = _find_node_by_name(get_tree().current_scene, "FireWall")
	if firewall and firewall.has_method("extinguish"):
		firewall.extinguish()

func _find_node_by_name(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var result = _find_node_by_name(child, node_name)
		if result:
			return result
	return null

func _find_buttons() -> void:
	var buttons: Array[Button] = []
	_collect_buttons(popup, buttons)
	for b in buttons:
		var name_lower := b.name.to_lower()
		if "run" in name_lower:
			run_button = b
		elif "reset" in name_lower or "close" in name_lower:
			reset_button = b
	if not run_button and buttons.size() > 0:
		run_button = buttons[0]
	if not reset_button and buttons.size() > 1:
		reset_button = buttons[1]

func _collect_buttons(node: Node, out: Array[Button]) -> void:
	for child in node.get_children():
		if child is Button:
			out.append(child)
		_collect_buttons(child, out)
