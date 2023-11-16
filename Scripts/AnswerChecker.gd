extends PanelContainer

const Answer = preload("res://Classes/Answer.gd")

var row1 : ButtonGroup 
var row2 : ButtonGroup 
var row3 : ButtonGroup 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	row1 = $CenterContainer/VBoxContainer/TitleText/Wrong.button_group
	row2 = $CenterContainer/VBoxContainer/ArtistText/Wrong.button_group
	row3 = $CenterContainer/VBoxContainer/AlbumText/Wrong.button_group
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func setup(ans : Answer, playID : int):
	
	$CenterContainer/VBoxContainer/Label.text = GameManager.getName(playID)
	
	$CenterContainer/VBoxContainer/TitleText/Label.text = ans.Title
	$CenterContainer/VBoxContainer/ArtistText/Label.text = ans.Artist
	
	if (ans.Album.length() != 0):
		$CenterContainer/VBoxContainer/AlbumText.show()
		$CenterContainer/VBoxContainer/AlbumText/Label.text = ans.Album

func getRowOutcome(pressedButton) -> int:
	if pressedButton == null: return 0
	match pressedButton.name:
		"Wrong":
			return 0
		"Right":
			return 1
		"Funny":
			return 2
		_:
			return 0
			
func _exit_tree() -> void:
	print(getRowOutcome(row1.get_pressed_button()))
	print(getRowOutcome(row2.get_pressed_button()))
	print(getRowOutcome(row3.get_pressed_button()))

func isFinished() -> bool:
	var temp = (row1.get_pressed_button() != null) and (row2.get_pressed_button() != null)
	if $CenterContainer/VBoxContainer/AlbumText.visible:
		return temp and row3.get_pressed_button() != null
	else:
		return temp
