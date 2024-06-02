extends Node
@export var character_card_scene: PackedScene;
@export var character_card_idle_sprite: Texture2D;
@export var slot_scene: PackedScene;
@export var slot_idle_sprite: Texture2D;

func _ready():
	initialize_character_card();
	initialize_slots();

func initialize_character_card():
	Global.character_card_ref = character_card_scene.instantiate();
	Global.character_card_ref.initialize(Global.character_card_base_info.id, Global.character_card_base_info.label, character_card_idle_sprite);
	Global.character_card_ref.position = Global.character_card_ref.card_info.initial_position;
	add_child(Global.character_card_ref);

func initialize_slots():
	create_rows();
	move_child(Global.character_card_ref, -1);

func create_rows(quantity = 2):
	# Tengo que crear una clase BoardCard para crear las cartas y modificar esta creación de los slots
	# Los slots deberían crearse una única vez al inicio y las cartas deberían crearse encima de la posición de los slots con esta misma funcionalidad
	Global.slot_refs = [];
	for i in range(quantity):
		for card in Global.test_deck[str(Global.last_row_created)]:
			var slot_id = get_slot_id_by_position_and_row(card.position, i);
			var slot = slot_scene.instantiate();
			slot.initialize(slot_id, card.label, card.idle_sprite);
			slot.position = Vector2(Global.slot_positions[str(slot_id)].x, Global.slot_positions[str(slot_id)].y);
			add_child(slot);
			Global.slot_refs.append(slot);
		Global.last_row_created += 1;
	Global.last_row_created -= 1;

func get_slot_id_by_position_and_row(position, row):
	match(position):
		"start":
			return 0 if row == 0 else 3;
		"middle":
			return 1 if row == 0 else 4;
		"end":
			return 2 if row == 0 else 5;
