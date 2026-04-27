extends CanvasLayer

@onready var book_icon: TextureButton = $BookIcon
@onready var notification: Label = $BookIcon/Notification
@onready var book_panel: Control = $BookPanel
@onready var title_label: Label = $BookPanel/TitleLabel
@onready var page_label: Label = $BookPanel/PageLabel
@onready var page_number_label: Label = $BookPanel/PageCounter
@onready var prev_button: Button = $BookPanel/PrevButton
@onready var next_button: Button = $BookPanel/NextButton
@onready var close_button: Button = $BookPanel/CloseButton

var pages: Array = []
var current_page: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	book_panel.visible = false
	book_icon.visible = true
	
	# ЗАГРУЗКА СТРАНИЦ ИЗ GLOBAL ПРИ СТАРТЕ СЦЕНЫ
	if "book_pages" in Global:
		pages = Global.book_pages.duplicate(true)
	
	if notification:
		notification.text = "!"
		notification.add_theme_font_size_override("font_size", 20)
		notification.modulate = Color(1.0, 0.213, 0.16, 1.0)
		notification.visible = false
	
	book_icon.pressed.connect(_on_icon_pressed)
	prev_button.pressed.connect(_on_prev_pressed)
	next_button.pressed.connect(_on_next_pressed)
	close_button.pressed.connect(_on_close_pressed)

func add_page(title: String, text: String) -> void:
	# Защита от дублирования страниц (если игрок жмет на ту же табличку)
	for p in pages:
		if p["title"] == title:
			return
			
	pages.append({"title": title, "text": text})
	Global.book_pages = pages.duplicate(true)
	
	if notification:
		notification.visible = true
	
	AudioManager.play_sfx("notification")

func _on_icon_pressed() -> void:
	if pages.is_empty():
		return
	
	AudioManager.play_sfx("open_paper")
	
	book_panel.visible = true
	book_icon.visible = false
	Global.input_blocked = true
	get_tree().paused = true
	current_page = 0
	_update_page()
	
	if notification:
		notification.visible = false

func _on_close_pressed() -> void:
	AudioManager.play_sfx("open_paper", -5.0, 0.8)
	
	book_panel.visible = false
	book_icon.visible = true
	Global.input_blocked = false
	get_tree().paused = false

func _on_prev_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		AudioManager.play_sfx("open_paper", -3.0, 1.1)
		_update_page()

func _on_next_pressed() -> void:
	if current_page < pages.size() - 1:
		current_page += 1
		AudioManager.play_sfx("open_paper", -3.0, 1.0)
		_update_page()

func _update_page() -> void:
	var page = pages[current_page]
	title_label.text = page["title"]
	page_label.text = page["text"]
	
	page_number_label.text = "%d/%d" % [current_page + 1, pages.size()]
	
	prev_button.disabled = (current_page == 0)
	next_button.disabled = (current_page >= pages.size() - 1)
