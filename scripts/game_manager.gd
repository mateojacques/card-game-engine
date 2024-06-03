extends Node
@export var character_card_scene: PackedScene;
@export var character_card_idle_sprite: Texture2D;
@export var board_card_scene: PackedScene;
@export var slot_scene: PackedScene;

func _ready():
	Global.game_manager_ref = self;
	initialize_slots();
	create_board_cards();
	create_board_cards();
	initialize_character_card();

func initialize_character_card():
	Global.character_card_ref = character_card_scene.instantiate();
	Global.character_card_ref.initialize(Global.character_card_base_info.id, Global.character_card_base_info.label, character_card_idle_sprite);
	Global.character_card_ref.position = Global.character_card_ref.card_info.initial_position;
	add_child(Global.character_card_ref);

func create_board_cards():
	Global.disable_interaction = true;
	var refs = Global.board_card_refs;
	var row_cards = Global.test_deck[str(Global.last_row_created)];
	if Global.last_row_created > 1:
		var previous_row = Global.test_deck[str(Global.last_row_created - 1)];
		# Remove first X card nodes - X is the last row size
		for card in refs.slice(0, previous_row.size()):
			card.queue_free();
		# Update refs array
		refs = refs.slice(previous_row.size(), refs.size());
		# Reposition previous row cards
		for card_index in previous_row.size():
			var slot_index = get_slot_id_by_position_and_row(previous_row[card_index].position, 0 if refs.find(refs[card_index], 0) <= previous_row.size() - 1 else 1);
			refs[card_index].card_info.slot_index = slot_index;
			refs[card_index].card_info.current_slot_position = Vector2(Global.slot_positions[str(slot_index)].x, Global.slot_positions[str(slot_index)].y);
	for card in row_cards:
		var board_card = board_card_scene.instantiate();
		refs.append(board_card);
		board_card.initialize(card.id, card.label, card.description, card.idle_sprite);
		var slot_index = get_slot_id_by_position_and_row(card.position, 0 if refs.find(board_card, 0) <= row_cards.size() - 1 else 1);
		board_card.card_info.slot_index = slot_index;
		board_card.position = Vector2(Global.slot_positions[str(slot_index)].x, Global.slot_positions[str(slot_index)].y - 700);
		add_child(board_card);
		board_card.card_info.current_slot_position = Vector2(Global.slot_positions[str(slot_index)].x, Global.slot_positions[str(slot_index)].y);
	Global.last_row_created += 1;
	Global.board_card_refs = refs;

func initialize_slots():
	create_rows();
	move_child(Global.character_card_ref, -1);

func create_rows(quantity = 2):
	# Tengo que crear una clase BoardCard para crear las cartas y modificar esta creación de los slots
	# Los slots deberían crearse una única vez al inicio y las cartas deberían crearse encima de la posición de los slots con esta misma funcionalidad
	for i in range(quantity * 3):
		var slot = slot_scene.instantiate();
		slot.initialize(i, "slot_"+str(i));
		slot.position = Vector2(Global.slot_positions[str(i)].x, Global.slot_positions[str(i)].y);
		add_child(slot);
		Global.slot_refs.append(slot);

func get_slot_id_by_position_and_row(position, row):
	match(position):
		"start":
			return 0 if row == 0 else 3;
		"middle":
			return 1 if row == 0 else 4;
		"end":
			return 2 if row == 0 else 5;
