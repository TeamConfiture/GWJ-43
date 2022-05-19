extends Control

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sound_bus = AudioServer.get_bus_index("SFX")
var ambiance_bus = AudioServer.get_bus_index("Amb")

func _ready():
	pass

# La fonction "Lerp" permet d'adoucir le changement de volume et éviter les clips audio lors du changement.
# Les chiffres après le lerp c'est le numéro d'indexation des bus en partant de la gauche dans le menu "Audio". Master = 0 / Underwater = 1 Etc...
# Ensuite, on dit " si tu es à -24 db tu mutes le canal plutot que de faire encore entendre le son. Globalement c'est l'idée.
func _on_Volume_General_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus,lerp(AudioServer.get_bus_volume_db(0),value, 0.5)) 
	$tickmaster.play(0.0)
	if value == -30:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)


func _on_Volume_Music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus,lerp(AudioServer.get_bus_volume_db(3),value, 0.5))
	$tickmusic.play(0.0)
	if value == -30:
		AudioServer.set_bus_mute(3, true)
	else:
		AudioServer.set_bus_mute(3, false)


func _on_Volume_Sound_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sound_bus,lerp(AudioServer.get_bus_volume_db(2),value, 0.5))
	$ticksfx.play(0.0)
	if value == -30:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)

func _on_Volume_Ambiant_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(ambiance_bus,lerp(AudioServer.get_bus_volume_db(4),value, 0.5))
	$tickamb.play(0.0)
	if value == -30:
		AudioServer.set_bus_mute(4, true)
	else:
		AudioServer.set_bus_mute(4, false)
