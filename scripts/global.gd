extends Node;

# Variables or constants that need to be present across all nodes in the game are stored here.

# CONSTANTS

const animation_speed = 12;

const card_height = 530;

const card_width = 352;

const character_card_base_info = {
	"id": 1,
	"label": "character_card",
	"position": {
		"y": 790 + (card_height / 2)
	}
}

const slot_positions = {
	"0": { "x": -237 - (card_width / 2), "y": 26 + (card_height / 2) },
	"1": { "x": 0, "y": 26 + (card_height / 2) },
	"2": { "x": 237 + (card_width / 2), "y": 26 + (card_height / 2) },
	"3": { "x": -237 - (card_width / 2), "y": -143 - (card_height / 2) },
	"4": { "x": 0, "y": -143 - (card_height / 2) },
	"5": { "x": 237 + (card_width / 2), "y": -143 - (card_height / 2) },
}

# VARIABLES

var board_card_refs = [];
var current_active_slot = -1;
var current_hovered_slot = null;
var character_card_ref: CharacterCard = null;
var disable_interaction = false;
var game_manager_ref = null;
var is_dragging = false;
var last_row_created = 0;
var mouse_is_hovering_slot = false;
var slot_refs = [];
var test_deck = {
	# First row has to have 3 cards
	"0": [
		{
		"id": "card_0",
		"label": "Card 0",
		"description": "Card 0 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_1",
		"label": "Card 1",
		"description": "Card 1 Description",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_2",
		"label": "Card 2",
		"description": "Card 2 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"1": [
		{
		"id": "card_3",
		"label": "Card 3",
		"description": "Card 3 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_4",
		"label": "Card 4",
		"description": "Card 4 Description",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_5",
		"label": "Card 5",
		"description": "Card 5 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"2": [
		{
		"id": "card_6",
		"label": "Card 6",
		"description": "Card 6 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_7",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_8",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"3": [
		{
		"id": "card_9",
		"label": "Card 6",
		"description": "Card 6 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_10",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_11",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"4": [
		{
		"id": "card_0",
		"label": "Card 6",
		"description": "Card 6 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_1",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_2",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"5": [
		{
		"id": "card_3",
		"label": "Card 6",
		"description": "Card 6 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_5",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"6": [
		{
		"id": "card_6",
		"label": "Card 6",
		"description": "Card 6 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_7",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"id": "card_8",
		"label": "Card 8",
		"description": "Card 8 Description",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
	"7": [
		{
		"id": "card_10",
		"label": "Card 6",
		"description": "Card 6 Description",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
	],
};
