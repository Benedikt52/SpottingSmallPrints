extends Node2D

# VARIABLEN HIER ANPASSEN
var memory_scene_path = "res://scenes/memory/memory.tscn"
var next_scene_path = "res://path/to/your_next_scene.tscn"
var max_game_moves = 50

var card = preload("res://scenes/memory/card.tscn")
var Textures = [
	preload("res://assets/memory/000.png"),
	preload("res://assets/memory/001.png"),
	preload("res://assets/memory/002.png"),
	preload("res://assets/memory/003.png"),
	preload("res://assets/memory/004.png"),
	preload("res://assets/memory/005.png"),
	preload("res://assets/memory/006.png"),
	preload("res://assets/memory/007.png"),
	preload("res://assets/memory/008.png"),
	preload("res://assets/memory/009.png")
]
var cards = []
var open_cards = []
var ROW = 4
var COL = 5
var PairsToBeFound = (ROW * COL) / 2

var gameMoves = 0
var gameMovesLabel

func _ready():
	setupHUD()
	for t in Textures:
		var newCard = card.instantiate()
		newCard.get_node("obverse").texture = t
		cards.append(newCard)
		var newCard_match = card.instantiate()
		newCard_match.get_node("obverse").texture = t
		cards.append(newCard_match)
		
	cards.shuffle()
		
	for row in ROW:
		for col in COL:
			var c = cards[col + row * 5]
			c.position = Vector2(125 * col, 125 * row)
			add_child(c)

func setupHUD():
	gameMovesLabel = get_node("CanvasLayer/PanelContainerTop/VBoxContainer/HBoxContainer/counter")
	gameMovesLabel.text = str(gameMoves)

func check():
	print(open_cards)
	
	if len(open_cards) >= 2:
		increase_move_count()
		for card in cards:
			card.can_control = false
		# prüfe ob selbe karte
		if open_cards[0] == open_cards[1]:
			$TurnBackTimer.start()
			return
		# match
		if open_cards[0].get_node("obverse").texture == \
			open_cards[1].get_node("obverse").texture:
			$DeleteTimer.start()
			PairsToBeFound -= 1
			# prüfe ob alle karten gefunden
			if PairsToBeFound == 0:
				on_all_pairs_found()
		# unmatch
		else:
			print("turnback timer start")
			$TurnBackTimer.start()

func continue_control():
	for card in cards:
		card.can_control = true
	open_cards = []
	
func _on_delete_timer_timeout():
	for card in open_cards:
		card.queue_free()
		cards.erase(card)
	continue_control()

func _on_turn_back_timer_timeout():
	for card in open_cards:
		card.get_node("AnimationPlayer").play("turn_back")
	continue_control()
	
func _on_scene_change_timer_timeout():
	# hier kann eine neue scene geladen werden 
	# zum beispiel: get_tree().change_scene(next_scene_path)
	print("Alle Paare gefunden! Scene wechsel.")
	
func on_all_pairs_found():
	$SceneChangeTimer.start()

var is_scene_changing = false
func _process(delta):
	if Input.is_key_pressed(KEY_Q) and not is_scene_changing:
		is_scene_changing = true
		print("q")
		# taste q gedrückt -> wechsel scene
		# zum beispiel: get_tree().change_scene(next_scene_path)

func _on_button_pressed():
	print("q") 
	# button q gedrückt -> wechsel scene
	# zum beispiel: get_tree().change_scene(next_scene_path)
	
func increase_move_count():
	gameMoves += 1
	setupHUD()
	if gameMoves >= max_game_moves:
		load_new_memory_game()

func load_new_memory_game():
	get_tree().reload_current_scene()
	print("new scene")
