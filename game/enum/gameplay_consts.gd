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

static var DAILY_ACTIVITY_STAT_GROWTH_LOOKUP: Dictionary = {
    Stats.Types.CRAFT: {
        Weather.Types.FAIR: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.HOT: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.CREATION, 2)
        ],
        Weather.Types.CLOUDY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.CREATION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2)
        ],
        Weather.Types.RAINY: [
            StatIncrease.new(Stats.Types.CRAFT, -1, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.MISTY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
     },
    Stats.Types.STUDY: {
        Weather.Types.FAIR: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.HOT: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.CLOUDY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.RAINY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.MISTY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
     },
    Stats.Types.PHYSICAL: {
        Weather.Types.FAIR: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.HOT: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.CLOUDY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.RAINY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
        Weather.Types.MISTY: [
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PRECISION, 2),
            StatIncrease.new(Stats.Types.CRAFT, Stats.Craft.PLANNING, 2)
        ],
     }

}