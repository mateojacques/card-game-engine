extends Node2D

var slot = {
	"id": null,
	"index": null,
	"current_card_ref": null,
};

var is_hovered = false;

func initialize(index: int, id: String):
	slot.id = id;
	slot.index = index;

func _process(_delta):
	 # If I dropped the card on a valid slot:
	if is_pickable_slot() and is_hovered and not Global.is_dragging and slot.current_card_ref:
		handle_place_card_in_slot();

func _on_area_2d_mouse_entered():
	if is_pickable_slot() and Global.is_dragging:
		set_hovered_state(true);

func _on_area_2d_mouse_exited():
	if is_pickable_slot():
		set_hovered_state(false);

func handle_place_card_in_slot():
	Global.current_active_slot = slot.index;
	# Send "placed card in x slot" signal??
	Global.game_manager_ref.handle_board_progression();
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
			return slot.index - Global.current_active_slot < 4;
		0, 1:
			return slot.index - Global.current_active_slot < 2;
		2:
			return slot.index - Global.current_active_slot > -2 and slot.index - Global.current_active_slot <= 0;

func set_hovered_state(hovered: bool):
	is_hovered = hovered;
	Global.current_hovered_slot = slot.index if hovered else null;
	# This global variable is used to know if we are dropping the card on a valid slot or not. If not it should snap back to its current slot position.
	Global.mouse_is_hovering_slot = hovered;
