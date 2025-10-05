class_name Mood

enum Types {
    RELAXED = 0,
    HAPPY = 1,
    SAD = 2,
    GRUMPY = 3,
    MOTIVATED = 4,
}

enum Conditional {
    ANY = -1,
    RELAXED = 0,
    HAPPY = 1,
    SAD = 2,
    GRUMPY = 3,
    MOTIVATED = 4,
}

static var MoodIconPaths: Array[String] = [
    "res://assets/art/mood_relaxed.png",
    "res://assets/art/mood_happy.png",
    "res://assets/art/mood_sad.png",
    "res://assets/art/mood_grumpy.png",
    "res://assets/art/mood_motivated.png",
]
