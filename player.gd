# player.gd
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var interact_hint: Label = $InteractHint
@export var SPEED: float = 150.0

var previous_direction := Vector2.ZERO
var _interactables: Array = []

func _ready() -> void:
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	interact_hint.visible = false

func _physics_process(_delta: float) -> void:
	# если консоль открыта — блокируем движение
	if Global.input_blocked:
		return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	update_animation(direction)

func _input(event) -> void:
	# Если глобально заблокирован ввод — игнорируем нажатия
	if Global.input_blocked:
		return

	# Обработка взаимодействия
	if event.is_action_pressed("interact") or (event is InputEventScreenTouch and event.pressed):
		_handle_interact()

func _handle_interact() -> void:
	var target = current_interactable()
	if target and target.has_method("interact"):
		target.interact(self)

func update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		return

	var new_animation = "idle"
	var should_flip_h = false

	if abs(direction.y) >= abs(direction.x):
		if direction.y < 0:
			new_animation = "run_up"
		elif direction.y > 0:
			new_animation = "run_down"
	else:
		new_animation = "run"
		should_flip_h = direction.x < 0

	if animated_sprite.animation != new_animation or should_flip_h != animated_sprite.flip_h or previous_direction != direction:
		animated_sprite.play(new_animation)
		animated_sprite.flip_h = should_flip_h

	previous_direction = direction

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

func current_interactable() -> Node:
	# очистка невалидных ссылок
	_interactables = _interactables.filter(func(x): return is_instance_valid(x))
	return _interactables.back() if _interactables else null
