extends Node

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
func SendAnswer(myID: int, blah : String) -> void: 
#	if(!Answers.has(myID)):
#		Answers[myID] = {
#			"ID" = myID,
#			"Answer" = blah
#		}
	
	var ans = Answer.new(blah, "art", "alb")
