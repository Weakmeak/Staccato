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
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	var scene = load("res://QuestionPrompt.tscn").instantiate()
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
	for i in GameManager.players:
		if i != 1: StartQuestion.rpc_id(i)
