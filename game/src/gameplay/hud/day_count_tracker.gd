extends Label

func _onDayCountChange(newDayCount: int) -> void:
    text = "Day\n%s" % newDayCount;
