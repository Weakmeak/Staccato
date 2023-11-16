extends Control

const reveal = preload("res://Scenes/AnswerReveal.tscn")

var cliplength : float
var questionLength : float
var songPath : String

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
		GameManager.currSong = InfoGetter.GetInfo(songPath)
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
	%PlayerCheck.text = "0/" + str(GameManager.playCount)  + " Answers"
	GameManager.answers_in.connect(answered)
	GameManager.answer_recieved.connect(updateCount)
	$Juke.play(playStart)
	targetPitch = 1
#	print(songPath.split("/")[-1])
	for i in GameManager.players:
			if i != 1: GameManager.StartQuestion.rpc_id(i, 60)
	

func updateCount(ans : int, play : int):
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT)
	%PlayerCheck.add_theme_color_override("font_color", Color.from_string("#44CF6B", Color.GREEN))
	%PlayerCheck.text = str(ans) + "/" + str(play)  + " Answers"
	t.tween_property(%PlayerCheck, "theme_override_colors/font_color", Color.WHITE, .5)

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
	var q = reveal.instantiate()
	q.setup()
	get_tree().root.add_child(q)
	
	var root = get_tree().get_root()
#	$"../Main Menu/hostScreen".show()
	root.remove_child(self)
	self.call_deferred("free")

func answered() -> void:
#	print("GOT IT")
	done = true

func _on_timeout() -> void:
	done = true
