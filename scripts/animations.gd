extends Node

# Every animation for any card in the game goes here.
# It has the following structure:
#
# [card_label]_[animation_name] = [
#	{
#		"path": string, # Path to the frame texture
#		"duration": int # Duration of the frame
#	}
# ];
#
# To access it from a component we can use the helper function add_frames_to_animation:
#
# Animation.add_frames_to_animation(frames, animation_name, animated_sprite_ref);

# HELPERS

func add_frames_to_animation(frames, animation_name, animated_sprite_ref):
	for frame_info in frames:
		var frame = load(frame_info.path);
		animated_sprite_ref.sprite_frames.add_frame(animation_name, frame, frame_info.duration);

# ANIMATIONS

var card_0_fade_in = [
	{
		"path": "res://assets/sprites/slot_0.png",
		"duration": 1,
	},
];

var card_1_fade_in = [
	{
		"path": "res://assets/sprites/slot_1.png",
		"duration": 1,
	},
];

var card_2_fade_in = [
	{
		"path": "res://assets/sprites/slot_2.png",
		"duration": 1,
	},
];

var card_3_fade_in = [
	{
		"path": "res://assets/sprites/slot_3.png",
		"duration": 1,
	},
];

var card_4_fade_in = [
	{
		"path": "res://assets/sprites/slot_4.png",
		"duration": 1,
	},
];

var card_5_fade_in = [
	{
		"path": "res://assets/sprites/slot_5.png",
		"duration": 1,
	},
];

var card_6_fade_in = [
	{
		"path": "res://assets/sprites/slot_6.png",
		"duration": 1,
	},
];

var card_7_fade_in = [
	{
		"path": "res://assets/sprites/slot_7.png",
		"duration": 1,
	},
];

var card_8_fade_in = [
	{
		"path": "res://assets/sprites/slot_8.png",
		"duration": 1,
	},
];

var card_9_fade_in = [
	{
		"path": "res://assets/sprites/slot_9.png",
		"duration": 1,
	},
];

var card_10_fade_in = [
	{
		"path": "res://assets/sprites/slot_10.png",
		"duration": 1,
	},
];

var card_11_fade_in = [
	{
		"path": "res://assets/sprites/slot_11.png",
		"duration": 1,
	},
];

var card_12_fade_in = [
	{
		"path": "res://assets/sprites/slot_12.png",
		"duration": 1,
	},
];
