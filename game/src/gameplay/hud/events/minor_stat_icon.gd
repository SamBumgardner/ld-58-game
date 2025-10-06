class_name MinorStatIcon extends TextureRect

var labelText: String:
    set(newValue):
        $MinorStatThreshold.text = newValue
    get():
        return $MinorStatThreshold.text;
