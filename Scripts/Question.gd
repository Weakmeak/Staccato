extends Control

var cliplength : float
var questionLength : float
var songPath : String
var songMetadata 

var playStart : float
var playEnd : float

var targetPitch : float = 0
var done : bool = false

func setup(clipLen, qLen) -> void:
	cliplength = clipLen
	questionLength = qLen
	
	var s : String = GameManager.randSong()
	if (s != "NO SONGS"):
		songPath = s
		InfoGetter.GetInfo(songPath)
		var aStre = GameManager.makeAudioStream(songPath)
		if aStre.get_length() < cliplength: 
			playStart = 0
			playEnd = aStre.get_length()
		else:
			playStart = randf_range(0, (aStre.get_length() - cliplength) )
			playEnd = playStart + cliplength
		$Juke.stream = aStre
		$Juke.pitch_scale = 0.01
		%Playhead.min_value = playStart
		%Playhead.max_value = playEnd
	
	$RadialTimer.timeLimit = questionLength

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.answers_in.connect(answered)
	$Juke.play(playStart)
	targetPitch = 1
#	print(songPath.split("/")[-1])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# pitch drop
	$Juke.pitch_scale = lerpf($Juke.pitch_scale, targetPitch, 0.33)
	
	# progress bar
	var prog = $Juke.get_playback_position()
	if $Juke.playing: %Playhead.value = prog
	if (prog > playEnd) || done:
		targetPitch = 0
		if $Juke.pitch_scale < 0.1:
			$Juke.stop()
	
	if done && !$Juke.playing:
		EXTERMINATE()



func EXTERMINATE() -> void:
#	await 
	var root = get_tree().get_root()
	$"../Main Menu/hostScreen".show()
	root.remove_child(self)
	self.call_deferred("free")

func answered() -> void:
	print("GOT IT")
	done = true

func _on_timeout() -> void:
	done = true
