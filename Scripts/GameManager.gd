extends Control

var players = {}
var songDirectory = ""
var songPaths = {}
var Answers = {}
var currSong

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer", "call_local")
func SendAnswer(myID: int, ttl : String, art : String, alb : String) -> void: 
	var ans = Answer.new(ttl, art, alb)
	if(!Answers.has(myID)):
		Answers[myID] = {
			"ID" = myID,
			"Answer" = ans
		}
		

@rpc("authority", "call_local")
func StartQuestion() -> void:
	var scene = load("res://Scenes/QuestionPrompt.tscn").instantiate()
	get_tree().root.add_child(scene)

@rpc("any_peer", "call_local")
func sendInfo(myID, name) -> void:
	if(!players.has(myID)):
		players[myID] = {
			"name" = name,
			"id" = myID,
			"score" = 0
		}

func findSongs(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# print("Found directory: " + path + "/" + file_name)
				findSongs(path + "/" + file_name)
			elif (file_name.ends_with(".mp3")):
				GameManager.songPaths[GameManager.songPaths.size()] = {
					"path" = (path + "/" + file_name)
				}
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func randSong():
	var songID = randi_range(0, GameManager.songPaths.size() - 1)
	
	print("SONG CHOSEN")
	print(GameManager.songPaths[songID].path)
	$hostScreen/VBoxContainer/FilepathTestLabel.text = GameManager.songPaths[songID].path
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = makeAudioStream(GameManager.songPaths[songID].path)
	$AudioStreamPlayer.play()

func makeAudioStream(path : String) -> AudioStream:
	if path.ends_with(".mp3"):
		var sound = AudioStreamMP3.new()
		sound.data = FileAccess.get_file_as_bytes(path)
		return sound
		
	var file = FileAccess.open("res://fail.mp3", FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound
	push_error("Loaded file was not supported!")

func playNewSong() -> void:
	randSong()
