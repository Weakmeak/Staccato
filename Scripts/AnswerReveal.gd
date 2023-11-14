extends Control

func setup():
	var temp = GameManager.currSong
	%TITLE.text = temp.title
	%ARTIST.text = temp.artist
	%ALBUM.text = temp.album
	%AlbArt.texture = temp.albArt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
