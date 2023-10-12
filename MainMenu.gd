extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_button_down() -> void:
	$startButtons.hide()
	$Header.show()
	$Header/headerText.text = "You are the Host!"
	$Back.show()


func _on_join_button_down() -> void:
	$startButtons.hide()
	$Header.show()
	$Header/headerText.text = "You are a player!"
	$Back.show()


func _on_back_button_down() -> void:
	$startButtons.show()
	$Header.hide()
	$Header/headerText.text = " "
	$Back.hide()
