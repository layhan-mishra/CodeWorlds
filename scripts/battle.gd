extends CanvasLayer

signal battle_finished(won: bool)

const CODIMALS: Array[String] = ["Segfaultle", "Nullbat", "Loopzard", "Recursaur"]

const QUESTIONS: Array[Dictionary] = [
	{
		"q": "What is the time complexity of binary search on a sorted array?",
		"choices": ["O(n)", "O(log n)", "O(n^2)", "O(1)"],
		"answer": 1,
	},
	{
		"q": "Which data structure uses LIFO ordering?",
		"choices": ["Queue", "Stack", "Heap", "Graph"],
		"answer": 1,
	},
	{
		"q": "What does a hash table give you on average for lookups?",
		"choices": ["O(1)", "O(log n)", "O(n)", "O(n log n)"],
		"answer": 0,
	},
]

var _codimal: String
var _question: Dictionary
var _choice_buttons: Array[Button] = []
var _result_label: Label
var _continue_button: Button

func _ready() -> void:
	layer = 10
	_codimal = CODIMALS.pick_random()
	_question = QUESTIONS.pick_random()
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.08, 0.14, 0.97)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 32)
	add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	margin.add_child(box)

	var title := Label.new()
	title.text = "A wild %s appeared!" % _codimal
	box.add_child(title)

	var question_label := Label.new()
	question_label.text = _question["q"]
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(question_label)

	for i in _question["choices"].size():
		var b := Button.new()
		b.text = _question["choices"][i]
		b.pressed.connect(_on_choice_pressed.bind(i))
		box.add_child(b)
		_choice_buttons.append(b)

	_result_label = Label.new()
	box.add_child(_result_label)

	_continue_button = Button.new()
	_continue_button.text = "Continue"
	_continue_button.visible = false
	_continue_button.pressed.connect(_on_continue_pressed)
	box.add_child(_continue_button)

	_choice_buttons[0].grab_focus()

func _on_choice_pressed(index: int) -> void:
	for b in _choice_buttons:
		b.disabled = true
	var correct: bool = index == _question["answer"]
	_result_label.text = ("Correct! You caught %s!" % _codimal) if correct \
		else ("Wrong! %s got away..." % _codimal)
	_continue_button.visible = true
	_continue_button.grab_focus()
	set_meta("won", correct)

func _on_continue_pressed() -> void:
	battle_finished.emit(get_meta("won", false))
	queue_free()