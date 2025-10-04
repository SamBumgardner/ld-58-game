class_name ActivityGenerator

static func generateActivities(day: Day, player: Player) -> Array[Activity]:
    var studyActivity = Activity.new(Stats.Types.STUDY, getStudyStats(day, player));
    var physicalActivity = Activity.new(Stats.Types.PHYSICAL, getPhysicalStats(day, player));
    var craftActivity = Activity.new(Stats.Types.CRAFT, getCraftStats(day, player));

    return [studyActivity, physicalActivity, craftActivity];


static func getStudyStats(day: Day, player: Player) -> Array[StatIncrease]:
    const study = Stats.Types.STUDY;

    # Standard stat benefit
    var statIncreases: Array[StatIncrease];
    match day.weather:
        Weather.Types.FAIR:
            statIncreases = [
                StatIncrease.new(study, Stats.Study.KNOWLEDGE, 2),
                StatIncrease.new(study, Stats.Study.WIT, 2)
            ]
        Weather.Types.HOT:
            statIncreases = [
                StatIncrease.new(study, player.getStrongestStatIndexForType(study), 2),
            ]
        Weather.Types.CLOUDY:
            statIncreases = [
                StatIncrease.new(study, Stats.Study.WIT, 2),
                StatIncrease.new(study, Stats.Study.MAGIC, 2)
            ]
        Weather.Types.RAINY:
            statIncreases = [
                StatIncrease.new(study, Stats.Study.MAGIC, 2),
                StatIncrease.new(study, Stats.Study.KNOWLEDGE, 2)
            ]
        Weather.Types.MISTY:
            statIncreases = [
                StatIncrease.new(study, player.getWeakestStatIndexForType(study), 2),
            ]
        _:
            statIncreases = []
    
    # Special bonuses
    var bonusIncreases: Array[StatIncrease];
    match day.weather:
        Weather.Types.HOT:
            if day.mood == Mood.Types.SAD:
                bonusIncreases = [
                    StatIncrease.new(study, player.getWeakestStatIndexForType(Stats.Types.PHYSICAL), 2),
                ]
        Weather.Types.RAINY:
            if day.mood == Mood.Types.SAD:
                bonusIncreases = [
                    StatIncrease.new(study, Stats.Study.WIT, 2),
                ]
        Weather.Types.MISTY:
            if day.mood == Mood.Types.RELAXED:
                bonusIncreases = [
                    StatIncrease.new(study, Stats.Study.WIT, 2),
                    StatIncrease.new(study, Stats.Study.KNOWLEDGE, 2),
                    StatIncrease.new(study, Stats.Study.MAGIC, 2)
                ]
        _:
            return []
    
    # Combine duplicates
    statIncreases.append_array(bonusIncreases);
    combineMatchingIncreases(statIncreases);

    return statIncreases;


static func getPhysicalStats(day: Day, player: Player) -> Array[StatIncrease]:
    const physical = Stats.Types.PHYSICAL;

    # Standard stat benefit
    var statIncreases: Array[StatIncrease];
    match day.weather:
        Weather.Types.FAIR:
            statIncreases = [
                StatIncrease.new(physical, Stats.Physical.STRENGTH, 2),
                StatIncrease.new(physical, Stats.Physical.COURAGE, 2)
            ]
        Weather.Types.HOT:
            statIncreases = [
                StatIncrease.new(physical, Stats.Physical.STRENGTH, 2),
                StatIncrease.new(physical, Stats.Physical.ENDURANCE, 2)
            ]
        Weather.Types.CLOUDY:
            statIncreases = [
                StatIncrease.new(physical, player.getStrongestStatIndexForType(physical), 2),
            ]
        Weather.Types.RAINY:
            statIncreases = [
                StatIncrease.new(physical, Stats.Physical.COURAGE, 2),
                StatIncrease.new(physical, Stats.Physical.ENDURANCE, 2)
            ]
        Weather.Types.MISTY:
            statIncreases = [
                StatIncrease.new(physical, player.getWeakestStatIndexForType(physical), 2),
            ]
        _:
            statIncreases = []
    
    # Special bonuses
    var bonusIncreases: Array[StatIncrease];
    match day.weather:
        Weather.Types.HOT:
            if day.mood == Mood.Types.GRUMPY:
                bonusIncreases = [
                    StatIncrease.new(physical, Stats.Physical.COURAGE, 2)
                ]
        Weather.Types.CLOUDY:
            if day.mood == Mood.Types.GRUMPY:
                bonusIncreases = [
                    StatIncrease.new(physical, player.getWeakestStatIndexForType(Stats.Types.CRAFT), 2),
                ]
        Weather.Types.MISTY:
            if day.mood == Mood.Types.RELAXED:
                bonusIncreases = [
                    StatIncrease.new(physical, Stats.Physical.STRENGTH, 2),
                    StatIncrease.new(physical, Stats.Physical.COURAGE, 2),
                    StatIncrease.new(physical, Stats.Physical.ENDURANCE, 2)
                ]
        _:
            return []
    
    # Combine duplicates
    statIncreases.append_array(bonusIncreases);
    combineMatchingIncreases(statIncreases);

    return statIncreases;


static func getCraftStats(day: Day, player: Player) -> Array[StatIncrease]:
    const craft = Stats.Types.CRAFT;

    # Standard stat benefit
    var statIncreases: Array[StatIncrease];
    match day.weather:
        Weather.Types.FAIR:
            statIncreases = [
                StatIncrease.new(craft, Stats.Craft.PRECISION, 2),
                StatIncrease.new(craft, Stats.Craft.PLANNING, 2)
            ]
        Weather.Types.HOT:
            statIncreases = [
                StatIncrease.new(craft, Stats.Craft.PLANNING, 2),
                StatIncrease.new(craft, Stats.Craft.CREATION, 2)
            ]
        Weather.Types.CLOUDY:
            statIncreases = [
                StatIncrease.new(craft, Stats.Craft.CREATION, 2),
                StatIncrease.new(craft, Stats.Craft.PRECISION, 2)
            ]
        Weather.Types.RAINY:
            statIncreases = [
                StatIncrease.new(craft, player.getStrongestStatIndexForType(craft), 2),
            ]
        Weather.Types.MISTY:
            statIncreases = [
                StatIncrease.new(craft, player.getWeakestStatIndexForType(craft), 2),
            ]
        _:
            statIncreases = []
    
    # Special bonuses
    var bonusIncreases: Array[StatIncrease];
    match day.weather:
        Weather.Types.CLOUDY:
            if day.mood == Mood.Types.HAPPY:
                bonusIncreases = [
                    StatIncrease.new(craft, Stats.Craft.PLANNING, 2)
                ]
        Weather.Types.RAINY:
            if day.mood == Mood.Types.HAPPY:
                bonusIncreases = [
                    StatIncrease.new(craft, player.getWeakestStatIndexForType(Stats.Types.STUDY), 2),
                ]
        Weather.Types.MISTY:
            if day.mood == Mood.Types.RELAXED:
                bonusIncreases = [
                    StatIncrease.new(craft, Stats.Craft.CREATION, 2),
                    StatIncrease.new(craft, Stats.Craft.PRECISION, 2),
                    StatIncrease.new(craft, Stats.Craft.PLANNING, 2)
                ]
        _:
            return []
    
    # Combine duplicates
    statIncreases.append_array(bonusIncreases);
    combineMatchingIncreases(statIncreases);

    return statIncreases;


static func combineMatchingIncreases(statIncreases: Array[StatIncrease]) -> Array[StatIncrease]:
    var result: Array[StatIncrease] = [];
    var memo = {};
    for increase in statIncreases:
        var key = "%s_%s" % [increase.statType, increase.subTypeIndex];
        var existing = memo.get(key);
        if existing != null:
            existing.changeAmount += increase.changeAmount;
        else:
            result.push_back(increase);
            memo[key] = increase;
    
    return result;