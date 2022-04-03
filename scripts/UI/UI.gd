extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var music_player = $"../MusicPlayer"
onready var sound_player = $"../SoundPlayer"


# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeScreen.visible = false
	$Menu/Label.text = "Mortals await.."
	$Menu/Resume.text = "Start!"
	$Menu/Resume.grab_focus()

func fade_out():
	$FadeScreen/AnimationPlayer.advance(0)
	$FadeScreen/AnimationPlayer.play("FadeOut")
#	yield($FadeScreen/AnimationPlayer,"animation_finished")

func fade_in():
	$FadeScreen/AnimationPlayer.advance(0)
	$FadeScreen/AnimationPlayer.play("FadeIn")
#	yield($FadeScreen/AnimationPlayer,"animation_finished")


func toggle_menu():
	if $Menu.visible:
		$Menu.hide()
		get_tree().paused = false
		if !get_parent().game_started:
			get_parent().game_started = false
			$Menu/Label.text = "Mortals wait.."
			$Menu/Resume.text = "Resume"
	else:
		$Menu.show()
		get_tree().paused = true
	sound_player.sound("click")


func hide_reload():
	$"Reload Panel".hide()


func show_reload(level_clear, score, next_level = false):
	var msg = ""
	if level_clear:
		msg = "Level cleared!\nScore: %s" % score
	else:
		msg = "Defeat...\nScore: %s" % score
	
	$"Reload Panel/Label".text = msg
	$"Reload Panel".show()
	if next_level:
		$"Reload Panel/NextLevel".show()
		$"Reload Panel/NextLevel".grab_focus()
	else:
		$"Reload Panel/NextLevel".hide()
		$"Reload Panel/Reload".grab_focus()
		
func show_victory(score):
	$"Victory screen".show()
	yield(get_tree().create_timer(1.0), "timeout")
	$"Victory screen/Final score".text = "Your final score: %s" % score


func _on_sound_toggle():
	if sound_player.toggle():
		$Menu/Sound/Toggle.text = "On"
		$Menu/Sound/HScrollBar.value = $Menu/Sound/HScrollBar.max_value
	else:
		$Menu/Sound/Toggle.text = "Off"
		$Menu/Sound/HScrollBar.value = $Menu/Sound/HScrollBar.min_value


func _on_sound_range_change(value):
	if value > -80:
		$Menu/Sound/Toggle.text = "On"
	else:
		$Menu/Sound/Toggle.text = "Off"
		
		
func _on_music_toggle():
	if music_player.toggle():
		$Menu/Music/Toggle.text = "On"
		$Menu/Music/HScrollBar.value = $Menu/Music/HScrollBar.max_value
	else:
		$Menu/Music/Toggle.text = "Off"
		$Menu/Music/HScrollBar.value = $Menu/Music/HScrollBar.max_value


func _on_music_range_change(value):
	if value != -80:
		$Menu/Music/Toggle.text = "On"
	else:
		$Menu/Music/Toggle.text = "Off"

