class_name GameplayConsts

const DEFAULT_CRAFTING_COOLDOWN: int = 5;

const ACTIVITY_WEATHER_NEXT_MOOD_LOOKUP: Dictionary = {
    Stats.Types.CRAFT: {
        Weather.Types.FAIR: Mood.Types.SAD,
        Weather.Types.HOT: Mood.Types.GRUMPY,
        Weather.Types.CLOUDY: Mood.Types.RELAXED,
        Weather.Types.RAINY: Mood.Types.HAPPY,
        Weather.Types.MISTY: Mood.Types.MOTIVATED,
    },
    Stats.Types.STUDY: {
        Weather.Types.FAIR: Mood.Types.GRUMPY,
        Weather.Types.HOT: Mood.Types.SAD,
        Weather.Types.CLOUDY: Mood.Types.HAPPY,
        Weather.Types.RAINY: Mood.Types.RELAXED,
        Weather.Types.MISTY: Mood.Types.MOTIVATED,
    },
    Stats.Types.PHYSICAL: {
        Weather.Types.FAIR: Mood.Types.HAPPY,
        Weather.Types.HOT: Mood.Types.RELAXED,
        Weather.Types.CLOUDY: Mood.Types.GRUMPY,
        Weather.Types.RAINY: Mood.Types.SAD,
        Weather.Types.MISTY: Mood.Types.MOTIVATED,
    }
}