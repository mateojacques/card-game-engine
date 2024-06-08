extends Node2D

var card_info = {
	"id": null, # Unique card identifier
	"label": null, # Label that the user will see as title of the card
	"description": null, # Text that informs the user about the card's effects
	"idle_sprite": null, # Texture to be shown if an animated sprite is not available
	"animated_sprite_ref": null, # Ref to the animated sprite of the card
	"animations": { # Animation names for reference when playing an animation before an action
		"fade_in": null
	},
	"slot_index": null, # Index of the slot this card is currently in
	"current_slot_position": null # Current slot position for the card
};

var t = 0.0;

func initialize(id: String, label: String, description: String, idle_sprite: Texture2D):
	card_info.id = id;
	card_info.label = label;
	card_info.description = description;
	card_info.animated_sprite_ref = $AnimatedSprite2D;
	card_info.idle_sprite = idle_sprite;

	if card_info.id+"_fade_in" in Animations:
		handle_fade_in_animation();
	else:
		handle_idle_animation();

func _process(delta):
	# If the slot this card is in is hovered while dragging, lower brightness of the card.
	modulate.v = 0.7 if Global.current_hovered_slot == card_info.slot_index and Global.is_dragging else 1.0;

func _physics_process(delta):
	if card_info.current_slot_position and card_info.current_slot_position.y - position.y >= 10 :
		t += delta * Global.lerp_speed;
		position = position.lerp(card_info.current_slot_position, t);
	else:
		card_info.current_slot_position = null;
		t = 0.0;

func handle_fade_in_animation():
	# Store fade in animation name with random id
	var animation_id = RandomNumberGenerator.new().randi_range(10, 10000);
	card_info.animations.fade_in = card_info.id+"_fade_in_"+str(animation_id);
	# Create and configure fade in animation
	card_info.animated_sprite_ref.sprite_frames.add_animation(card_info.animations.fade_in);
	card_info.animated_sprite_ref.sprite_frames.set_animation_loop(card_info.animations.fade_in, false);
	card_info.animated_sprite_ref.sprite_frames.set_animation_speed(card_info.animations.fade_in, Global.animation_speed);
	# Get frames from Animations file and add them to the fade in animation
	var frames = Animations[card_info.id+"_fade_in"] if card_info.id+"_fade_in" in Animations else [];
	Animations.add_frames_to_animation(frames, card_info.animations.fade_in, card_info.animated_sprite_ref);
	# Play fade in animation
	card_info.animated_sprite_ref.play(card_info.animations.fade_in);

func handle_idle_animation():
	card_info.animated_sprite_ref.sprite_frames.add_animation(card_info.id+"_idle");
	card_info.animated_sprite_ref.sprite_frames.set_animation_loop(card_info.id+"_idle", false);
	card_info.animated_sprite_ref.sprite_frames.add_frame(card_info.id+"_idle", card_info.idle_sprite);
	card_info.animated_sprite_ref.play(card_info.id+"_idle");


func _on_animated_sprite_2d_animation_finished():
	handle_idle_animation();
