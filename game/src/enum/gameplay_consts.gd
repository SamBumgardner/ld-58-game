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

static var WEATHER_ENHANCEMENT_FACTORS: Dictionary = generateWeatherEnhancements();
static var MOOD_ENHANCEMENT_FACTORS: Dictionary = generateMoodEnhancements();

static func generateWeatherEnhancements() -> Dictionary:
    const STANDARD_BONUS = 1;
    const STANDARD_PENALTY = -1;

    var result = {};
    for weatherType: Weather.Types in Weather.Types.values():
        var enhancedStatTypes: Array[Stats.Types];
        var reducedStatTypes: Array[Stats.Types];
        match weatherType:
            Weather.Types.FAIR:
                enhancedStatTypes = []
                reducedStatTypes = []
            Weather.Types.HOT:
                enhancedStatTypes = [Stats.Types.PHYSICAL]
                reducedStatTypes = [Stats.Types.STUDY]
            Weather.Types.CLOUDY:
                enhancedStatTypes = [Stats.Types.CRAFT]
                reducedStatTypes = [Stats.Types.PHYSICAL]
            Weather.Types.RAINY:
                enhancedStatTypes = [Stats.Types.STUDY]
                reducedStatTypes = [Stats.Types.CRAFT]
            Weather.Types.MISTY:
                enhancedStatTypes = []
                reducedStatTypes = [Stats.Types.STUDY, Stats.Types.PHYSICAL, Stats.Types.CRAFT]
            _:
                push_error();
        
        var enhancements: Array[EnhancementFactor] = [];

        for enhancedStatType in enhancedStatTypes:
            var enhancement = EnhancementFactor.new(weatherType as Weather.Conditional,
                Mood.Conditional.ANY, enhancedStatType, [],
                EnhancementFactor.EnhancementType.FLAT_ADD, STANDARD_BONUS);
            enhancements.push_back(enhancement);

        for reducedStatType in reducedStatTypes:
            var enhancement = EnhancementFactor.new(weatherType as Weather.Conditional,
                Mood.Conditional.ANY, reducedStatType, [],
                EnhancementFactor.EnhancementType.FLAT_ADD, STANDARD_PENALTY);
            enhancements.push_back(enhancement);

        result[weatherType] = enhancements;
            
    return result;


static func generateMoodEnhancements() -> Dictionary:
    const STANDARD_BONUS = 1;
    const STANDARD_PENALTY = -1;

    var result = {};
    for moodType: Mood.Types in Mood.Types.values():
        var enhancedStatTypes: Array[Stats.Types];
        var reducedStatTypes: Array[Stats.Types];
        match moodType:
            Mood.Types.RELAXED:
                enhancedStatTypes = []
                reducedStatTypes = []
            Mood.Types.HAPPY:
                enhancedStatTypes = [Stats.Types.CRAFT]
                reducedStatTypes = [Stats.Types.STUDY]
            Mood.Types.SAD:
                enhancedStatTypes = [Stats.Types.STUDY]
                reducedStatTypes = [Stats.Types.PHYSICAL]
            Mood.Types.GRUMPY:
                enhancedStatTypes = [Stats.Types.PHYSICAL]
                reducedStatTypes = [Stats.Types.CRAFT]
            Mood.Types.MOTIVATED:
                enhancedStatTypes = [Stats.Types.STUDY, Stats.Types.PHYSICAL, Stats.Types.CRAFT]
                reducedStatTypes = []
            _:
                push_error();
        
        var enhancements: Array[EnhancementFactor] = [];

        for enhancedStatType in enhancedStatTypes:
            var enhancement = EnhancementFactor.new(Weather.Conditional.ANY,
                moodType as Mood.Conditional, enhancedStatType, [],
                EnhancementFactor.EnhancementType.FLAT_ADD, STANDARD_BONUS);
            enhancements.push_back(enhancement);

        for reducedStatType in reducedStatTypes:
            var enhancement = EnhancementFactor.new(Weather.Conditional.ANY,
                moodType as Mood.Conditional, reducedStatType, [],
                EnhancementFactor.EnhancementType.FLAT_ADD, STANDARD_PENALTY);
            enhancements.push_back(enhancement);

        result[moodType] = enhancements;
            
    return result;
