extends Timer

var timeLimit = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TimeWheel.max_value = timeLimit
	%TimeText.text = timeToString(timeLimit)
	start(timeLimit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%TimeWheel.value = time_left
	%TimeText.text = timeToString(time_left)

func timeToString(t : float) -> String:
	return str(int(round(t)))
