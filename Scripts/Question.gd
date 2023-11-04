extends Control

var cliplength : float
var questionLength : float
var songPath : String
var songMetadata 

var playStart : float
var playEnd : float

func setup(clipLen, qLen, sPath) -> void:
	cliplength = clipLen
	questionLength = qLen
	songPath = sPath
	
	var s = GameManager.randSong()
	if (s != "NO SONGS"):
		var aStre = GameManager.makeAudioStream(s)
		if aStre.get_length() < cliplength: 
			playStart = 0
			playEnd = aStre.get_length()
		else:
			playStart = randf_range(0, (aStre.get_length() - cliplength) )
			playEnd = playStart + cliplength
		$Juke.stream = aStre
		%Playhead.min_value = playStart
		%Playhead.max_value = playEnd
	
	$RadialTimer.timeLimit = questionLength

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Juke.play(playStart)
	print(songPath.split("/")[-1])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var prog = $Juke.get_playback_position()
	%Playhead.value = prog
	if prog > playEnd: $Juke.stop()
	

func EXTERMINATE() -> void:
	var root = get_tree().get_root()
	$"../Main Menu/hostScreen".show()
	root.remove_child(self)
	self.call_deferred("free")


func _on_timeout() -> void:
	EXTERMINATE()
