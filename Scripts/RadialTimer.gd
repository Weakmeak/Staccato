extends Timer

var timeLimit = 30.0

func _init(timeLim = 30.0) -> void:
	timeLimit = timeLim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TimeWheel.max_value = timeLimit
	%TimeText.text = timeToString(timeLimit)
	start(timeLimit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%TimeWheel.value = time_left
	%TimeText.text = timeToString(time_left)

func timeToString(t : float) -> String:
	return str(int(round(t)))
