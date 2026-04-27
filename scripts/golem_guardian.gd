extends StaticBody2D
# ==========================
# УЗЛЫ
# ==========================
var idle_sprite: AnimatedSprite2D
var attack_sprite: AnimatedSprite2D
var laser: AnimatedSprite2D
var dialog_before: Array[Label] = []
var dialog_after: Label
var interaction_area: Area2D
# ==========================
# ПЕРЕМЕННЫЕ
# ==========================
var rng = RandomNumberGenerator.new()
var is_chest_opened: bool = false
var player_in_range: bool = false
# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	print("Golem _ready started")
	
	idle_sprite = get_node_or_null("AnimatedSprite2D")
	attack_sprite = get_node_or_null("AttackSprite")
	laser = get_node_or_null("LaserOverlay")
	dialog_after = get_node_or_null("DialogLabels/DialogAfter")
	
	# РЕКУРСИВНЫЙ ПОИСК InteractionArea
	interaction_area = _find_node_by_name(self, "InteractionArea")
	
	for i in range(1, 4):
		var lbl = get_node_or_null("DialogLabels/DialogBefore" + str(i))
		if lbl:
			dialog_before.append(lbl)
	
	print("Found ", dialog_before.size(), " dialog labels")
	print("Found interaction_area: ", interaction_area != null)
	
	if idle_sprite:
		idle_sprite.play("idle")
	if attack_sprite:
		attack_sprite.visible = false
	if laser:
		laser.visible = false
	
	_hide_all_dialogs()
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
		print("InteractionArea connected")
	else:
		push_warning("InteractionArea NOT FOUND!")
	
	if Global.guardian_chest_opened:
		print("Loaded saved state")
		is_chest_opened = true
		_remove_obstacle_immediately()

# ==========================
# ОБНАРУЖЕНИЕ ИГРОКА
# ==========================
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		print("Player entered")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		_hide_all_dialogs()
		print("Player left")

# ==========================
# НАЖАТИЕ E
# ==========================
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range and not Global.input_blocked:
		print("E pressed")
		interact()

# ==========================
# ДИАЛОГИ (ИСПРАВЛЕННЫЕ)
# ==========================
func interact() -> void:
	print("Interact, chest opened:", is_chest_opened)
	
	if is_chest_opened:
		_show_dialog(dialog_after)
	else:
		if dialog_before.size() > 0:
			var idx = rng.randi_range(0, dialog_before.size() - 1)
			_show_dialog(dialog_before[idx])

func _show_dialog(label: Label) -> void:
	if not is_instance_valid(label):
		print("ERROR: Invalid label")
		return
	
	_hide_all_dialogs()
	
	# ПРИНУДИТЕЛЬНАЯ ВИДИМОСТЬ И ПОЗИЦИЯ
	label.visible = true
	label.modulate = Color(1, 1, 1, 0)  # Полностью прозрачный, но белый
	label.z_index = 100  # Поверх всего
	
	print("Showing: ", label.name, " at pos: ", label.global_position)
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): 
		if is_instance_valid(label):
			label.visible = false
	)

func _hide_all_dialogs() -> void:
	for lbl in dialog_before:
		if is_instance_valid(lbl):
			lbl.visible = false
			lbl.modulate.a = 0.0
	if is_instance_valid(dialog_after):
		dialog_after.visible = false
		dialog_after.modulate.a = 0.0

# ==========================
# ОТКРЫТИЕ СУНДУКА
# ==========================
func on_chest_opened() -> void:
	if is_chest_opened:
		return
	
	print("Chest sequence started")
	is_chest_opened = true
	Global.guardian_chest_opened = true
	
	_show_dialog(dialog_after)
	_perform_attack()

# ==========================
# АТАКА И ЛАЗЕР
# ==========================
func _perform_attack() -> void:
	if attack_sprite:
		idle_sprite.visible = false
		attack_sprite.visible = true
		attack_sprite.play("default")
	
	await get_tree().create_timer(1.0).timeout
	
	if attack_sprite:
		attack_sprite.visible = false
		attack_sprite.stop()
	if idle_sprite:
		idle_sprite.visible = true
		idle_sprite.play("idle")
	
	if laser:
		laser.visible = true
		laser.play("default")
		
		var anim_name = laser.animation
		var fps = laser.sprite_frames.get_animation_speed(anim_name)
		var frame_count = laser.sprite_frames.get_frame_count(anim_name)
		var duration = frame_count / fps
		
		print("Laser: ", duration, "s")
		await get_tree().create_timer(duration).timeout
		
		laser.visible = false
		laser.stop()
		print("Laser done")
	
	_destroy_obstacle()

# ==========================
# УНИЧТОЖЕНИЕ СТЕНЫ (ИСПРАВЛЕННОЕ)
# ==========================
func _destroy_obstacle() -> void:
	var wall = get_node_or_null("../../rubble_wall")
	if not wall:
		wall = get_tree().current_scene.get_node_or_null("world/rubble_wall")
	
	if not wall:
		push_error("rubble_wall NOT FOUND!")
		return
	
	print("Found wall: ", wall.name)
	
	# ЗАТУХАЕМ ВСЕ ДОЧЕРНИЕ СПРАЙТЫ/ТАЙЛМАПЫ
	var children_to_fade = []
	for child in wall.get_children():
		if child is CanvasItem and not child is CollisionShape2D:
			children_to_fade.append(child)
			print("Will fade: ", child.name, " (", child.get_class(), ")")
	
	if children_to_fade.size() > 0:
		var tween = create_tween()
		for child in children_to_fade:
			tween.parallel().tween_property(child, "modulate:a", 0.0, 0.8)
		await tween.finished
		print("Fade complete")
	
	# Отключение коллизий
	for child in wall.get_children():
		if child is CollisionShape2D:
			child.disabled = true
			print("Disabled: ", child.name)

func _remove_obstacle_immediately() -> void:
	var wall = get_node_or_null("../../rubble_wall")
	if not wall:
		wall = get_tree().current_scene.get_node_or_null("world/rubble_wall")
	
	if wall:
		# Скрываем все дочерние спрайты
		for child in wall.get_children():
			if child is CanvasItem:
				child.visible = false
			if child is CollisionShape2D:
				child.disabled = true

# ==========================
# ПОМОЩНИК
# ==========================
func _find_node_by_name(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var result = _find_node_by_name(child, node_name)
		if result:
			return result
	return null
