extends Label

signal story_finished

@export var story_text: StoryText

@export var max_words_per_chunk: int = 3
@export var letter_delay: float = 0.04
@export var delay_between_chunks: float = 0.6

# Kurangi sedikit supaya teks tidak terlalu mepet pinggir label
@export var safe_padding: float = 20.0

var words: PackedStringArray = PackedStringArray()
var current_word_index: int = 0


func _ready() -> void:
	text = ""

	# Biar Label tidak keluar layar secara horizontal
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	clip_text = true

	if story_text == null:
		text = "StoryText belum dipasang."
		return

	words = story_text.content.split(" ", false)

	await play_story()

	# Kirim tanda kalau story sudah selesai
	story_finished.emit()


func play_story() -> void:
	while current_word_index < words.size():
		var chunk_text: String = get_safe_chunk()
		await type_text(chunk_text)
		await get_tree().create_timer(delay_between_chunks).timeout


func get_safe_chunk() -> String:
	var chunk_words: PackedStringArray = PackedStringArray()
	var max_width: float = size.x - safe_padding

	# Jaga-jaga kalau ukuran Label belum kebaca
	if max_width <= 0:
		max_width = get_viewport_rect().size.x - safe_padding

	for i in range(max_words_per_chunk):
		if current_word_index >= words.size():
			break

		var next_word: String = words[current_word_index]
		var candidate_words := PackedStringArray(chunk_words)
		candidate_words.append(next_word)

		var candidate_text: String = " ".join(candidate_words)

		if is_text_too_wide(candidate_text, max_width):
			if chunk_words.is_empty():
				chunk_words.append(next_word)
				current_word_index += 1

			break

		chunk_words.append(next_word)
		current_word_index += 1

	return " ".join(chunk_words)


func is_text_too_wide(value: String, max_width: float) -> bool:
	var font: Font = get_theme_font("font")
	var font_size: int = get_theme_font_size("font_size")

	var text_size: Vector2 = font.get_string_size(
		value,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)

	return text_size.x > max_width


func type_text(full_text: String) -> void:
	text = ""

	for i in range(full_text.length()):
		text = full_text.substr(0, i + 1)
		await get_tree().create_timer(letter_delay).timeout
