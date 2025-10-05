class_name Weather

enum Types {
    FAIR = 0,
    HOT = 1,
    CLOUDY = 2,
    RAINY = 3,
    MISTY = 4,
}

enum Conditional {
    ANY = -1,
    FAIR = 0,
    HOT = 1,
    CLOUDY = 2,
    RAINY = 3,
    MISTY = 4,
}

static var WeatherIconPaths: Array[String] = [
    "res://assets/art/weather_fair.png",
    "res://assets/art/weather_hot.png",
    "res://assets/art/weather_cloudy.png",
    "res://assets/art/weather_rainy.png",
    "res://assets/art/weather_misty.png",
]
