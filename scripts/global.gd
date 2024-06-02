extends Node;

# Variables or constants that need to be present across all nodes in the game are stored here.

# CONSTANTS

const animation_speed = 12;

const character_card_base_info = {
	"id": 1,
	"label": "character_card",
	"position": {
		"y": 790 + 265
	}
}

const slot_positions = {
	"0": { "x": -237 - 176, "y": 26 + 265 },
	"1": { "x": 0, "y": 26 + 265 },
	"2": { "x": 237 + 176, "y": 26 + 265 },
	"3": { "x": -237 - 176, "y": -143 - 265 },
	"4": { "x": 0, "y": -143 - 265 },
	"5": { "x": 237 + 176, "y": -143 - 265 },
}

# VARIABLES

var current_active_slot = -1;
var character_card_ref: CharacterCard = null;
var last_row_created = 0;
var mouse_is_hovering_slot = false;
var slot_refs = [];
var test_deck = {
	"0": [
		{
		"label": "card_1",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/slot_1.png"),
		},
		{
		"label": "card_2",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/slot_2.png"),
		},
		{
		"label": "card_3",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/slot_3.png"),
		},
	],
	"1": [
		{
			"label": "card_4",
			"position": "start",
			"idle_sprite": load("res://assets/sprites/slot_4.png"),
		},
		{
			"label": "card_5",
			"position": "middle",
			"idle_sprite": load("res://assets/sprites/slot_5.png"),
		},
		{
			"label": "card_6",
			"position": "end",
			"idle_sprite": load("res://assets/sprites/slot_6.png"),
		},
	],
	"2": [
		{
			"label": "card_7",
			"position": "start",
			"idle_sprite": load("res://assets/sprites/slot_7.png"),
		},
		{
			"label": "card_8",
			"position": "middle",
			"idle_sprite": load("res://assets/sprites/slot_8.png"),
		},
		{
			"label": "card_9",
			"position": "end",
			"idle_sprite": load("res://assets/sprites/slot_9.png"),
		},
	],
	"3": [
		{
			"label": "card_10",
			"position": "start",
			"idle_sprite": load("res://assets/sprites/slot_10.png"),
		},
		#{
			#"label": "card_11",
			#"position": "middle",
			#"idle_sprite": load("res://assets/sprites/slot_11.png"),
		#},
		{
			"label": "card_12",
			"position": "end",
			"idle_sprite": load("res://assets/sprites/slot_12.png"),
		},
	],
};
