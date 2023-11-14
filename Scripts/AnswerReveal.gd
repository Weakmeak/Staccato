extends Control

func setup():
	%TITLE.text = GameManager.currSong.title
	%ARTIST.text = GameManager.currSong.artist
	%ALBUM.text = GameManager.currSong.album
	%AlbArt.texture = GameManager.currsong.getArt()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
