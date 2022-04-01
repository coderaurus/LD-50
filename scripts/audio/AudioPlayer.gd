extends AudioStreamPlayer

export var ost : Dictionary = {}
var fade_step = 10

func song_playing(song):
	for key in ost.keys():
		if stream == ost.get(key) and key == song:
			return true
	return false

func mute_music():
	volume_db = -80
	
func unmute_music():
	volume_db = -10

func fade():
	while volume_db > -80:
		volume_db -= fade_step
		yield(get_tree().create_timer(0.1), "timeout")
	stream_paused = true
	stream = null
	stop()

func song(song = "", fade = false):
	stop()
	var last_song = stream
	if ost.has(song):
		if fade and stream != null:
			while volume_db > -80:
				volume_db -= fade_step
				yield(get_tree().create_timer(0.05), "timeout")
		stop()
		stream = ost.get(song)
		if fade:
			while volume_db < -10:
				volume_db += fade_step
				yield(get_tree().create_timer(0.05), "timeout")
		play()
		print("Playing now ", stream)
		emit_signal("finished", last_song)
