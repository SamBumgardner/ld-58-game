class_name MajorStatIcon extends TextureRect

var labelText: String:
    set(newValue):
        $MajorStatThreshold.text = newValue
    get():
        return $MajorStatThreshold.text;
