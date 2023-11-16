extends Control

const SongData = preload("res://Classes/SongData.gd")

var players = {}
var songDirectory = ""
var songPaths = []
var Answers = {}
var currSong : SongData

var playCount: int:
	get:
		return players.size()

signal answers_in
signal answer_recieved

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

@rpc("any_peer", "call_local")
func SendAnswer(myID: int, ttl : String, art : String, alb : String) -> void: 
	var ans = Answer.new(ttl, art, alb)
	if(!Answers.has(myID)):
		Answers[myID] = {
			"ID" = myID,
			"Answer" = ans
		}
		
		answer_recieved.emit(Answers.size(), players.size())
		
		if Answers.size() == players.size():
			answers_in.emit()
		

@rpc("authority", "call_local")
func StartQuestion(seconds : float) -> void:
	var scene = load("res://Scenes/QuestionPrompt.tscn").instantiate()
	scene.set_timer(seconds)
	get_tree().root.add_child(scene)

@rpc("any_peer", "call_local")
func sendInfo(myID, playerName) -> void:
	if(!players.has(myID)):
		players[myID] = {
			"name" = playerName,
			"id" = myID,
			"score" = 0
		}
		
func getName(playID : int) -> String:
	if(players.has(playID)): return players[playID].name
	else: 
		return "MissingNo"

func findSongs(path):
	var dir = DirAccess.open(path)
	if dir:
		songPaths.clear()
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# print("Found directory: " + path + "/" + file_name)
				findSongs(path + "/" + file_name)
			elif (file_name.ends_with(".mp3")):
				GameManager.songPaths.push_back(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func randSong() -> String:
	if GameManager.songPaths.size() > 0: return GameManager.songPaths.pick_random()
	else: return "NO SONGS"
	
func makeAudioStream(path : String) -> AudioStream:
#	print("PATH RECEIVED: " + path)
	if path.ends_with(".mp3"):
		var sound = AudioStreamMP3.new()
		sound.data = FileAccess.get_file_as_bytes(path)
		return sound
		
	var file = FileAccess.open("res://fail.mp3", FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	push_error("Loaded file was not supported!")
	return sound

func callScene(source: String):
	var scene = load(source).instantiate()
	get_tree().root.add_child(scene)
