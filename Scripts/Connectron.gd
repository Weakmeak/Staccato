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
func _process(_delta: float) -> void:
	pass

func HostGame() -> bool:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 17)
	if error != OK:
		print ("You made a fucky-wucky! >:(")
		return false
	multiplayer.set_multiplayer_peer(peer)
	return true

func JoinGame() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.set_multiplayer_peer(peer)

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
	GameManager.sendInfo.rpc_id(1, multiplayer.get_unique_id(), "name")

#called on CLIENT ONLY
func connection_failed() -> void:
	print("Connected failed, we'll get 'em next time!")
