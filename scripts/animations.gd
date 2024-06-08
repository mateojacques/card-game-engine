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
