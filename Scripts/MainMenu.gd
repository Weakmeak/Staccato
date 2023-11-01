extends Control

@export var address = "127.0.0.1"
@export var port = 42069

var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.allow_object_decoding = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameManager.Answers.size() > 0):
		var firstKey = GameManager.Answers.keys()[0]
		var ans : Answer = GameManager.Answers[firstKey].Answer
		# var Text : String = ans.Title + ", " + ans.Artist + ", " + ans.Album
		var Text = "WE GOT IT"
		$hostScreen/VBoxContainer/FilepathTestLabel.text = Text

func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 17)
	if error != OK:
		print ("You made a fucky-wucky! >:(")
		return
		
	# peer.get_host().compress()
	multiplayer.set_multiplayer_peer(peer)
	
	$startButtons.hide()
	$Header.show()
	$Header/headerText.text = "You are the Host!"
	$Back.show()
	$hostScreen.show()

func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.set_multiplayer_peer(peer)

func _on_back_button_down() -> void:
	$startButtons.show()
	$Header.hide()
	$Header/headerText.text = " "
	$Back.hide()
	
	#peer.disconnect()

@rpc("any_peer", "call_local")
func sendInfo(myID, name) -> void:
	if(!GameManager.players.has(myID)):
		GameManager.players[myID] = {
			"name" = name,
			"id" = myID,
			"score" = 0
		}

@rpc("authority", "call_local")
func StartQuestion() -> void:
	var scene = load("res://Scenes/QuestionPrompt.tscn").instantiate()
	get_tree().root.add_child(scene)

# CONNECTIVITY

#called on SERVER AND CLIENTS
#THIS IS WHERE YOU PUT INFO ABOUT THE PLAYER, DIPSHIT
func peer_connected(id) -> void:
	print("Player Connected: " + str(id))

#called on SERVER AND CLIENTS
func peer_disconnected(id) -> void:
	print("Player Disconnected: " + str(id))

#called on CLIENT ONLY
func connected_to_server() -> void:
	print("Connected to server!")
	sendInfo.rpc_id(1, multiplayer.get_unique_id(), "name")
	$startButtons.hide()
	$Header.show()
	$Header/headerText.text = "You are a player!"
	$Back.show()

#called on CLIENT ONLY
func connection_failed() -> void:
	print("Connected failed, we'll get 'em next time!")

func _on_send_button_pressed() -> void:
	GameManager.Answers.clear()
	for i in GameManager.players:
		if i != 1: StartQuestion.rpc_id(i)

func _on_file_search_button_pressed() -> void:
	$FileDialog.popup()

func _on_file_dialog_dir_selected(dir: String) -> void:
	GameManager.songDirectory = dir 
	$hostScreen/VBoxContainer/FilepathTestLabel.text = dir
	dir_contents(dir)
	#for i in GameManager.songPaths:
		#print(GameManager.songPaths[i].path)
	if (GameManager.songPaths.size() != 0): $hostScreen/VBoxContainer/HBoxContainer/PlayNewSong.visible = true

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# print("Found directory: " + path + "/" + file_name)
				dir_contents(path + "/" + file_name)
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
