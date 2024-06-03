extends Node2D
class_name CharacterCard

var card_info = {
	"id": null,
	"label": null,
	"idle_sprite": null,
	"animated_sprite_ref": null,
	"area": null,
	"initial_position": Vector2(0, Global.character_card_base_info.position.y),
	"current_slot_position": Vector2(0, Global.character_card_base_info.position.y),
};

var t = 0.0;

func initialize(id: int, label: String, idle_sprite: Texture2D):
	card_info.id = id;
	card_info.label = label;
	card_info.idle_sprite = idle_sprite;
	card_info.animated_sprite_ref = $AnimatedSprite2D;
	card_info.area = $CharacterCardArea;
	card_info.animated_sprite_ref.sprite_frames.add_animation("character_card_idle");
	card_info.animated_sprite_ref.sprite_frames.add_frame("character_card_idle", idle_sprite);
	card_info.animated_sprite_ref.play("character_card_idle");

func _physics_process(delta):
	# The card always snap back to its current slot position with a seamless transition
	t += delta * 0.4;
	if Global.is_dragging:
		global_position = get_global_mouse_position();
	else:
		position = position.lerp(card_info.current_slot_position, t);

func _unhandled_input(event):
	if Global.is_dragging and event.is_action_released("start_drag"):
		Global.is_dragging = false;
		t = 0.0;

func _on_area_2d_input_event(viewport, event, shape_idx):
	# Drag mechanic
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		Global.is_dragging = true;
