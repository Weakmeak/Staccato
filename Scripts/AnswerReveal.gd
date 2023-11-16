extends Control

func setup():
	var temp = GameManager.currSong
	%TITLE.text = temp.title
	%ARTIST.text = temp.artist
	%ALBUM.text = temp.album
	%AlbArt.texture = temp.albArt
	
var ansPos
var textPos
var buttPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ansPos = %Answer.position
	textPos = $Leadup.position
	buttPos = $Next.position
	%Answer.set_position(  Vector2(ansPos.x - get_viewport().size.x, ansPos.y)  )
	$Next.set_position(  Vector2(buttPos.x, get_viewport().size.y + 75)  )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_drumroll_end() -> void:
	%Answer.show()
	$Next.show()
	$Timer.start()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_parallel(true)
	tween.tween_property($Leadup, "position", Vector2(textPos.x, 60), .5)
	tween.tween_property($Answer, "position", ansPos, .75)
	


func _after_delay() -> void:
	$Crash.play()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property($Next, "position", buttPos, .75)
	

func  KILL():
#	$"../Main Menu/hostScreen".show()
	GameManager.callScene("res://Scenes/Scoring.tscn")
	var root = get_tree().get_root()
	root.remove_child($".")
	$".".call_deferred("free")


func _on_next_pressed() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.finished.connect(KILL)
	
	tween.tween_property($".", "position", Vector2($".".position.x, get_viewport().size.y + 75), .75)
	
