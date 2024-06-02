extends Node2D

@onready var game_manager = get_parent();

var slot = {
	"id": null,
	"label": null,
	"idle_sprite": null,
	"animated_sprite": null,
	"animations":
		{
			"fade_in": null
		},
};

var is_hovered = false;

func initialize(id: int, label: String, idle_sprite: Texture2D):
	slot.id = id;
	slot.label = label;
	slot.idle_sprite = idle_sprite;
	slot.animated_sprite = $AnimatedSprite2D;

	handle_fade_in_animation();

func _process(delta):
	 # If I dropped the card on a valid slot:
	if is_pickable_slot() and is_hovered and not Global.character_card_ref.is_dragging:
		handle_place_card_in_slot();

func _on_area_2d_mouse_entered():
	if is_pickable_slot() and Global.character_card_ref.is_dragging:
		set_hovered_state(true);

func _on_area_2d_mouse_exited():
	if is_pickable_slot():
		set_hovered_state(false);

func handle_fade_in_animation():
	# Store fade in animation name with random id
	var animation_id = RandomNumberGenerator.new().randi_range(10, 10000);
	slot.animations.fade_in = slot.label+"_fade_in_"+str(animation_id);
	# Create and configure fade in animation
	slot.animated_sprite.sprite_frames.add_animation(slot.animations.fade_in);
	slot.animated_sprite.sprite_frames.set_animation_loop(slot.animations.fade_in, false);
	slot.animated_sprite.sprite_frames.set_animation_speed(slot.animations.fade_in, Global.animation_speed);
	# Get frames from Animations file and add them to the fade in animation
	var frames = Animations[slot.label+"_fade_in"] if slot.label+"_fade_in" in Animations else [];
	Animations.add_frames_to_animation(frames, slot.animations.fade_in, slot.animated_sprite);
	# Play fade in animation
	slot.animated_sprite.play(slot.animations.fade_in);

func handle_place_card_in_slot():
	Global.current_active_slot = slot.id;
	for i in range(Global.slot_refs.size()):
		# Play dissapear animation
		# TODO
		# Delete all slots in the used row
		Global.slot_refs[i].queue_free();
	# Create 2 rows unless I've reached the last row of the deck, in that case create only 1
	var is_last_row = not Global.test_deck.size() / 2 >= Global.last_row_created;
	game_manager.create_rows(1 if is_last_row else 2);
	# Set character card horizontal position to this slot horizontal position
	# The vertical position always remains the same as the initial one for the character
	var new_position = Vector2(position.x,Global.character_card_base_info.position.y);
	# Lock x axis to the slot x position for better transition
	Global.character_card_ref.position.x = position.x;
	# We modify current slot position to know where the card should snap back after placing it (on an valid slot or not)
	Global.character_card_ref.card_info.current_slot_position = new_position;
	# End the movement by disabling hovered state until the card is dragged again
	is_hovered = false;

func is_pickable_slot():
	# Return if the current slot is pickable from the character card perspective by measuring how far away they are
	match(Global.current_active_slot):
		-1:
			return slot.id - Global.current_active_slot < 4;
		0, 1:
			return slot.id - Global.current_active_slot < 2;
		2:
			return slot.id - Global.current_active_slot > -2 and slot.id - Global.current_active_slot <= 0;

func set_hovered_state(hovered: bool):
	modulate.v = 0.7 if hovered else 1;
	is_hovered = hovered;
	# This global variable is used to know if we are dropping the card on a valid slot or not. If not it should snap back to its current slot position.
	Global.mouse_is_hovering_slot = hovered;
