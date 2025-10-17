extends Node

@onready var player := AudioStreamPlayer.new()

var tracks = {
	"menu": preload("res://Cabezones/assets/audio/Menu.ogg"),
	"match": preload("res://Cabezones/assets/audio/Play.ogg")
}

func _ready():
	add_child(player)
	player.bus = "Music"
	player.autoplay = false
	player.volume_db = -6

func play(track: String):
	if tracks.has(track):
		if player.stream != tracks[track]:
			player.stream = tracks[track]
			player.play()
