extends Node

var title : String
var artist : String
var album : String

var albArt : ImageTexture

func setup(ttl : String, art : String, alb : String, tex : ImageTexture): # , tex : Texture2D
	title = ttl
	artist = art
	album = alb
	albArt = tex
	toConsole()

func toConsole():
	print("\n\n\n\n\n\n\n\n\nAMONG US")
