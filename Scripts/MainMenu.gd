extends Control

var ansCount = 0
const Question = preload("res://Scenes/Question.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.Answers.size() != ansCount:
		ansCount = GameManager.Answers.size()
		
		if (GameManager.Answers.size() > 0):
			var Text : String = ""
			# var Text = "WE GOT IT"
			for k in GameManager.Answers.keys():
				var ans : Answer = GameManager.Answers[k].Answer
				Text += ans.Title + ", " + ans.Artist + ", " + ans.Album + "\n"
			$hostScreen/VBoxContainer/FilepathTestLabel.text = Text
		else:
			$hostScreen/VBoxContainer/FilepathTestLabel.text = ""

func _on_host_button_down() -> void:
	if Connectron.HostGame():
		$startButtons.hide()
		$Header.show()
		$Header/headerText.text = "You are the Host!"
		$Back.show()
		$hostScreen.show()

func _on_join_button_down() -> void:
	Connectron.JoinGame()
	$startButtons.hide()
	$Header.show()
	$Header/headerText.text = "You are a player!"
	$Back.show()

func _on_back_button_down() -> void:
	$startButtons.show()
	$Header.hide()
	$Header/headerText.text = " "
	$Back.hide()

@rpc("authority", "call_local")
func StartQuestion() -> void:
	var scene = load("res://Scenes/QuestionPrompt.tscn").instantiate()
	get_tree().root.add_child(scene)
	print("Connected failed, we'll get 'em next time!")

func _on_send_button_pressed() -> void:
	GameManager.Answers.clear()
	for i in GameManager.players:
		if i != 1: StartQuestion.rpc_id(i)
	$hostScreen.hide()
	var q = Question.instantiate()
	q.setup(15, 30, GameManager.randSong())
	get_tree().root.add_child(q)

func _on_file_search_button_pressed() -> void:
	$FileDialog.popup()

func _on_file_dialog_dir_selected(dir: String) -> void:
	GameManager.songDirectory = dir 
	GameManager.findSongs(dir)
	$hostScreen/VBoxContainer/FilepathTestLabel.text = str(GameManager.songPaths.size()) + " songs found"
	if (GameManager.songPaths.size() != 0): $hostScreen/VBoxContainer/HBoxContainer/SendButton.disabled = false
	
func setHostState(state := true) -> void:
	if state: $hostScreen.show()
	else: $hostScreen.hide()
