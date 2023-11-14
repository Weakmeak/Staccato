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

func getTitle() -> String:
	return title

func getArtist() -> String:
	return artist
	
func getAlbum() -> String:
	return album
	
func getArt() -> ImageTexture:
	return albArt
