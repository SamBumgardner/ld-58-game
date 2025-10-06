extends Button

func _ready():
    var tween := create_tween()
    tween.tween_interval(.5);
    tween.tween_property(self, "self_modulate", Color.GOLD, .1);
    tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC);
    tween.tween_property(self, "self_modulate", Color.WHITE, 5);
