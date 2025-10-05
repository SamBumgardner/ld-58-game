class_name EndDaySummary extends Control

# Activity Stat 
const PREAMBLE = "Dear Diary,
I worked on [img=48]%s[/img] today.

Here's how it went:"

# Activity Stat, Weather, New Mood, DaysRemaining, NextEventTitle, CharacterName
const CONCLUSION = "[center][img=48]%s[/img] on a [img=48]%s[/img] day left me feeling [img=48]%s[/img][/center]

I have %d days left until 
[indent]\"%s\"[/indent]
I hope I'll be ready.

Your pal,
%s"

@onready var preamble: Label = $%Preamble;
@onready var conclusion: Label = $%Conclusion;
@onready var statChangeDisplays: Array[Node] = $%StatChanges.get_children();

func setValues(trainedStat: Stats.Types, statChanges: Array[StatIncrease],
        currentWeather: Weather.Types, nextMood: Mood.Types, daysRemaining: int,
        nextEventTitle: String, playerName: String) -> void:
    preamble.text = PREAMBLE % Stats.PrimaryStatIconPaths[trainedStat];
    conclusion.text = CONCLUSION % [
        Stats.PrimaryStatIconPaths[trainedStat],
        Weather.WeatherIconPaths[currentWeather],
        Mood.MoodIconPaths[nextMood],
        daysRemaining,
        nextEventTitle,
        playerName
    ]

    for statCategoryRequirement: StatCategoryRequirements in statChangeDisplays:
        statCategoryRequirement.displayChanges(statChanges);