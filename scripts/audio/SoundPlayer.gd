extends AudioStreamPlayer


export var sounds : Dictionary = {}

func toggle() -> bool:
	if volume_db == -80:
		unmute_sounds()
		return true
	else:
		mute_sounds()
		return false


func mute_sounds():
	volume_db = -80
	
func unmute_sounds():
	volume_db = 0
	sound("click")

func sound(sfx_name = ""):
	if sounds.has(sfx_name):
		stream = sounds.get(sfx_name)
		play(0.0, volume_db)

func play(from_position=0.0, volume = -80 ):
	var asp = self.duplicate(DUPLICATE_USE_INSTANCING)
	get_parent().add_child(asp)
	asp.mix_target = mix_target
	if volume > -80:
		asp.volume_db = volume
	else:
		asp.volume_db = volume_db
	asp.stream = stream
	asp.play()
	yield(asp, "finished")
	asp.queue_free()


func _on_range_changed(value):
	volume_db = value
	sound("click")
