extends TextureRect

func _onMoodChange(newMood: Mood.Types) -> void:
    texture = load(Mood.MoodIconPaths[newMood]);
