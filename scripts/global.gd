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
const initial_rows = 2;
const lerp_speed = 0.5;
const slot_positions = {
	"0": { "x": -237 - (card_width / 2), "y": 100 + (card_height / 2) },
	"1": { "x": 0, "y": 100 + (card_height / 2) },
	"2": { "x": 237 + (card_width / 2), "y": 100 + (card_height / 2) },
	"3": { "x": -237 - (card_width / 2), "y": -(card_height / 2) },
	"4": { "x": 0, "y": -(card_height / 2) },
	"5": { "x": 237 + (card_width / 2), "y": -(card_height / 2) },
}

# VARIABLES

var board_card_refs = [];
var current_active_slot = -1;
var current_hovered_slot = null;
var character_card_ref: CharacterCard = null;
var disable_interaction = false;
var game_manager_ref = null;
var is_dragging = false;
var last_row_created = -1;
var mouse_is_hovering_slot = false;
var slot_refs = [];
var test_deck = {
	# First row has to have 3 cards
	"0": [
		{
		"id": "pass_upwards",
		"label": "Pase corto",
		"description": "Pasa la pelota a un compañero.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/pass_upwards_idle.png"),
		},
		{
		"id": "long_ball",
		"label": "Pase largo",
		"description": "Despeja el balón hacia la posición de un compañero.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/long_ball_idle.png"),
		},
		{
		"id": "dribble",
		"label": "Dribble",
		"description": "Pasar entre los defensores con velocidad.",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/dribble_idle.png"),
		},
	],
	"1": [
		{
		"id": "rest",
		"label": "Descansar",
		"description": "Frena y recupera el aliento.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/rest_idle.png"),
		},
		{
		"id": "jog",
		"label": "Trotar",
		"description": "Avanza en el campo con esfuerzo moderado.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/jog_idle.png"),
		},
		{
		"id": "sprint",
		"label": "Esprintar",
		"description": "Sigue la jugada al tope de velocidad.",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/sprint_idle.png"),
		},
	],
	"2": [
		{
		"id": "pass_backwards",
		"label": "Pase hacia atrás",
		"description": "Reiniciar la jugada con un compañero.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/pass_backwards_idle.png"),
		},
		{
		"id": "hold",
		"label": "Frenar",
		"description": "Sostener el balón.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/hold_idle.png"),
		},
		{
		"id": "skill",
		"label": "Regatear",
		"description": "Intentar un regate con habilidad sobre un rival.",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/skill_idle.png"),
		},
	],
	"3": [
		{
		"id": "reposition",
		"label": "Reposicionarse",
		"description": "Ubicarse en el campo de manera ventajosa.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/reposition_idle.png"),
		},
		{
		"id": "stretch",
		"label": "Estirar",
		"description": "Recuperar capacidades mediante el estiramiento.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/stretch_idle.png"),
		},
		{
		"id": "water_bottle",
		"label": "Botella de agua",
		"description": "Hidratarse para recuperar energía.",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/water_bottle_idle.png"),
		},
	],
	"4": [
		{
		"id": "midfielder",
		"label": "Mediocampista",
		"description": "¡Un mediocampista quiere frenar tu carrera!",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/midfielder_idle.png"),
		},
	],
	"5": [
		{
		"id": "direction_left",
		"label": "Izquierda",
		"description": "Ataca por la banda izquierda.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/direction_left_idle.png"),
		},
		{
		"id": "direction_center",
		"label": "Centro",
		"description": "Ataca por el centro.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/direction_center_idle.png"),
		},
		{
		"id": "direction_right",
		"label": "Derecha",
		"description": "Ataca por la banda derecha.",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/direction_right_idle.png"),
		},
	],
	"6": [
		{
		"id": "control_ball",
		"label": "Controlar",
		"description": "Controla y queda en posesión del balón.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/control_ball_idle.png"),
		},
		{
		"id": "energetic_bar",
		"label": "Barra energética",
		"description": "Recupera algo de energía.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/energetic_bar_idle.png"),
		},
		{
		"id": "defender_1",
		"label": "Defensor",
		"description": "¡Un defensor quiere cortar tu carrera!",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/defender_idle.png"),
		},
	],
	"7": [
		{
		"id": "defender_2",
		"label": "Defensor",
		"description": "¡Un defensor quiere cortar tu carrera!",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/defender_idle.png"),
		},
		{
		"id": "defender_3",
		"label": "Defensor",
		"description": "¡Un defensor quiere cortar tu carrera!",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/defender_idle.png"),
		},
		{
		"id": "defender_4",
		"label": "Defensor",
		"description": "¡Un defensor quiere cortar tu carrera!",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/defender_idle.png"),
		},
	],
	"8": [
		{
		"id": "cover_space",
		"label": "Cubrir espacios",
		"description": "Corre a cubrir los huecos en la defensa rival.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/cover_space_idle.png"),
		},
	],

	"9": [
		{
		"id": "clumsy_shot",
		"label": "Tiro torpe",
		"description": "Remata con torpeza esperando que el balón ingrese.",
		"position": "start",
		"idle_sprite": load("res://assets/sprites/clumsy_shot_idle.png"),
		},
		{
		"id": "strong_shot",
		"label": "Tiro fuerte",
		"description": "Remata con poca puntería y mucha fuerza.",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/strong_shot_idle.png"),
		},
		{
		"id": "finesse_shot",
		"label": "Tiro colocado",
		"description": "Remata con gran calidad contra el palo.",
		"position": "end",
		"idle_sprite": load("res://assets/sprites/finesse_shot_idle.png"),
		},
	],
	"10": [
		{
		"id": "goalkeeper",
		"label": "Arquero",
		"description": "¡El arquero intentará detener tu tiro!",
		"position": "middle",
		"idle_sprite": load("res://assets/sprites/goalkeeper_idle.png"),
		},
	],
};
