extends CharacterBody2D

# ==========================
# УЗЛЫ
# ==========================
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var interact_hint: Label = $InteractHint
@onready var step_timer: Timer = $StepTimer

# ==========================
# ПАРАМЕТРЫ
# ==========================
@export var SPEED: float = 110.0

# ==========================
# ПЕРЕМЕННЫЕ
# ==========================
var _interactables: Array = []

# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	interact_hint.visible = false
	
	if Global.should_load_position:
		position = Vector2(Global.player_spawn_x, Global.player_spawn_y)
		Global.should_load_position = false

# ==========================
# ФИЗИКА И ДВИЖЕНИЕ
# ==========================
func _physics_process(_delta: float) -> void:
	if Global.input_blocked:
		step_timer.stop()
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		return
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	move_and_slide()
	_update_animation(direction)
	_handle_footsteps()

# ==========================
# ЗВУКИ ШАГОВ
# ==========================
func _handle_footsteps() -> void:
	if velocity.length() > 10.0:
		if step_timer.is_stopped():
			_play_step_sound()
			step_timer.start()
	else:
		step_timer.stop()

func _play_step_sound() -> void:
	var vol = -15.0 + randf_range(-2.0, 2.0)
	var pit = randf_range(0.9, 1.1)
	AudioManager.play_sfx("walk", vol, pit)

# ==========================
# АНИМАЦИЯ
# ==========================
func _update_animation(direction: Vector2) -> void:
	# Если нет ввода ИЛИ персонаж физически стоит на месте (например, уперся в стену)
	if direction == Vector2.ZERO or velocity.length() < 10.0:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		return
	
	var new_animation := "idle"
	var should_flip_h := false
	
	if abs(direction.y) >= abs(direction.x):
		new_animation = "run_up" if direction.y < 0 else "run_down"
	else:
		new_animation = "run"
		should_flip_h = direction.x < 0
	
	if animated_sprite.animation != new_animation or should_flip_h != animated_sprite.flip_h:
		animated_sprite.play(new_animation)
		animated_sprite.flip_h = should_flip_h

# ==========================
# ВЗАИМОДЕЙСТВИЕ
# ==========================
func _input(event) -> void:
	if Global.input_blocked:
		return
	
	if event.is_action_pressed("interact"):
		_handle_interact()

func _handle_interact() -> void:
	var target = _current_interactable()
	if target and target.has_method("interact"):
		target.interact(self)

# ==========================
# ОБРАБОТКА INTERACTABLES
# ==========================
func _on_interaction_area_entered(area: Area2D) -> void:
	var target = area.get_parent()
	if target and target.has_method("interact"):
		_interactables.append(target)
	_update_interact_hint()

func _on_interaction_area_exited(area: Area2D) -> void:
	var target = area.get_parent()
	if target:
		_interactables.erase(target)
	_update_interact_hint()

func _update_interact_hint() -> void:
	interact_hint.visible = _interactables.size() > 0

func _current_interactable() -> Node:
	_interactables = _interactables.filter(func(x): return is_instance_valid(x))
	return _interactables.back() if _interactables else null
