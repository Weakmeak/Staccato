extends Control


const ansCheck = preload("res://Scenes/AnswerChecker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var s = GameManager.currSong
	%TopText.text = s.title + "\n" + s.artist + "\n" + s.album
	
	
	for A in GameManager.Answers.keys():
		var newCheck = ansCheck.instantiate()
		
		var plID : int = GameManager.Answers[A].ID
		var ans = GameManager.Answers[A].Answer
		
		newCheck.setup(ans, plID)
		
		$VBoxContainer/ScrollContainer/Answers.add_child(newCheck)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_next_pressed() -> void:
	$"../Main Menu/hostScreen".show()
#	GameManager.callScene("res://Scenes/Scoring.tscn")
	var root = get_tree().get_root()
	root.remove_child($".")
	$".".call_deferred("free")
