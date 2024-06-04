extends Node
@export var character_card_scene: PackedScene;
@export var character_card_idle_sprite: Texture2D;
@export var board_card_scene: PackedScene;
@export var slot_scene: PackedScene;

func _ready():
	Global.game_manager_ref = self;
	initialize_slots();
	initialize_character_card();
	for _i in range(Global.initial_rows):
		handle_board_progression();

func initialize_character_card():
	Global.character_card_ref = character_card_scene.instantiate();
	Global.character_card_ref.initialize(Global.character_card_base_info.id, Global.character_card_base_info.label, character_card_idle_sprite);
	Global.character_card_ref.position = Global.character_card_ref.card_info.initial_position;
	add_child(Global.character_card_ref);

func handle_board_progression():
	if Global.last_row_created == Global.test_deck.size():
		print("End!");
		return;

	Global.disable_interaction = true;
	var refs = Global.board_card_refs;
	var prev_row = str(Global.last_row_created - 1);
	var last_row = str(Global.last_row_created);
	var next_row = str(Global.last_row_created + 1);

	# Handle removal and repositioning if not the first row
	if Global.last_row_created > 0:
		refs = delete_bottom_row(refs);

	if Global.last_row_created + 1 != Global.test_deck.size():
		var row_cards = Global.test_deck[next_row];
		# Create new cards
		for card_data in row_cards:
			var board_card = board_card_scene.instantiate();
			refs.append(board_card);

			board_card.initialize(card_data.id, card_data.label, card_data.description, card_data.idle_sprite);

			var refs_from_bottom_row = Global.test_deck[last_row] if Global.last_row_created > 0 else row_cards;
			var slot_index = get_slot_id_by_position_and_row(
				card_data.position,
				0 if refs.find(board_card, 0) <= refs_from_bottom_row.size() - 1 else 1
			);
			board_card.card_info.slot_index = slot_index;
			board_card.position.y = -700;
			add_child(board_card);
			board_card.card_info.current_slot_position = Vector2(Global.slot_positions[str(slot_index)].x, Global.slot_positions[str(slot_index)].y);
			set_slot_current_card_ref(Global.slot_refs[slot_index], board_card);

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

func set_slot_current_card_ref(slot_ref, card_ref):
	slot_ref.slot.current_card_ref = card_ref;

func delete_bottom_row(refs):
	var prev_row = str(Global.last_row_created - 1);
	var last_row = str(Global.last_row_created);
	var last_row_cards = Global.test_deck[last_row];
	var prev_row_cards = Global.test_deck[prev_row];

	for slot_ref in Global.slot_refs:
		set_slot_current_card_ref(slot_ref, null);


	# Remove first X card nodes - X is the soon to be deleted row size
	for card in refs.slice(0, prev_row_cards.size()):
		card.queue_free();

	# Update refs array
	refs = refs.slice(prev_row_cards.size(), refs.size());

	# Reposition previous row cards
	for i in range(last_row_cards.size()):
		var slot_index = get_slot_id_by_position_and_row(
			last_row_cards[i].position,
			0 if refs.find(refs[i], 0) <= last_row_cards.size() - 1 else 1
		);
		var card_info = refs[i].card_info;
		card_info.slot_index = slot_index;
		card_info.current_slot_position = Vector2(Global.slot_positions[str(slot_index)].x, Global.slot_positions[str(slot_index)].y);
		set_slot_current_card_ref(Global.slot_refs[slot_index], refs[i]);

	return refs;
