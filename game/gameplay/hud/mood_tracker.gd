extends Label

func _onMoodChange(newMood: Mood.Types) -> void:
    text = "Mood: %s" % Mood.Types.find_key(newMood);
