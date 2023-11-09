extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_title_text_changed(_new_text: String) -> void:
	updateButtonState()


func _on_artist_text_changed(_new_text: String) -> void:
	updateButtonState()


func _on_album_text_changed(_new_text: String) -> void:
	updateButtonState()

func updateButtonState() -> void:
	var ttl_Len = %Title.text.length()
	var art_Len = %Artist.text.length()
	var alb_Len = %Album.text.length()
	
	%AnswerButton.disabled = !(ttl_Len > 0 && art_Len > 0 && alb_Len > 0)

func _on_answer_button_pressed() -> void:
#	var ans : Answer = Answer.new(%Title.text, %Artist.text, %Album.text)
	GameManager.SendAnswer.rpc_id(1, multiplayer.get_unique_id(), %Title.text, %Artist.text, %Album.text)
	EXTERMINATE()

func _on_timeout() -> void:
	GameManager.SendAnswer.rpc_id(1, multiplayer.get_unique_id(), %Title.text, %Artist.text, %Album.text)
	EXTERMINATE()
	
func set_timer(seconds : float) -> void:
	$CenterContainer/RadialTimer.timeLimit = seconds

func EXTERMINATE() -> void:
	var root = get_tree().get_root()
	root.remove_child($".")
	$".".call_deferred("free")
