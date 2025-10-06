class_name PreviewInfo extends Control

const TITLE = "Tomorrow's %s:";

@export var previewType: ConditionOverride.Types;

@onready var tomorrowTitle: Label = $%TomorrowTitle;
@onready var tomorrowTexture: TextureRect = $%TomorrowTexture;
@onready var improveTexture: TextureRect = $%ImproveTexture;
@onready var improveLabel: Label = $%ImproveTextureLabel;
@onready var weakenTexture: TextureRect = $%WeakenTexture;
@onready var weakenLabel: Label = $%WeakenTextureLabel;
@onready var bonusEffectTextures: Array[Node] = $%BonusEffectTextures.get_children();
@onready var bonusEffectLabel: Label = $%BonusEffectTextureLabel;

func setValues(tomorrowTypeIndex: int):
    tomorrowTitle.text = TITLE % "Weather" if previewType == ConditionOverride.Types.WEATHER else TITLE % "Mood"
    var improveTexturePath: String;
    var weakenTexturePath: String;
    var bonusEffectTexturePaths: Array[String];

    if previewType == ConditionOverride.Types.WEATHER:
        tomorrowTexture.texture = load(Weather.WeatherIconPaths[tomorrowTypeIndex]);
        
        match tomorrowTypeIndex:
            Weather.Types.FAIR:
                improveTexturePath = "";
                weakenTexturePath = "";
                bonusEffectTexturePaths = [];
            Weather.Types.HOT:
                improveTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.PHYSICAL];
                weakenTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.STUDY];
                bonusEffectTexturePaths = [
                    Mood.MoodIconPaths[Mood.Types.GRUMPY],
                    Mood.MoodIconPaths[Mood.Types.SAD]
                ];
            Weather.Types.CLOUDY:
                improveTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.CRAFT];
                weakenTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.PHYSICAL];
                bonusEffectTexturePaths = [
                    Mood.MoodIconPaths[Mood.Types.HAPPY],
                    Mood.MoodIconPaths[Mood.Types.GRUMPY]
                ];
            Weather.Types.RAINY:
                improveTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.STUDY];
                weakenTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.CRAFT];
                bonusEffectTexturePaths = [
                    Mood.MoodIconPaths[Mood.Types.SAD],
                    Mood.MoodIconPaths[Mood.Types.HAPPY]
                ];
            Weather.Types.MISTY:
                improveTexturePath = "";
                weakenTexturePath = "all";
                bonusEffectTexturePaths = [
                    Mood.MoodIconPaths[Mood.Types.RELAXED],
                ];
                
    if previewType == ConditionOverride.Types.MOOD:
        tomorrowTexture.texture = load(Mood.MoodIconPaths[tomorrowTypeIndex]);
        
        match tomorrowTypeIndex:
            Mood.Types.RELAXED:
                improveTexturePath = "";
                weakenTexturePath = "";
                bonusEffectTexturePaths = [];
            Mood.Types.HAPPY:
                improveTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.CRAFT];
                weakenTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.STUDY];
                bonusEffectTexturePaths = [
                    Weather.WeatherIconPaths[Weather.Types.CLOUDY],
                    Weather.WeatherIconPaths[Weather.Types.RAINY]
                ];
            Mood.Types.SAD:
                improveTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.STUDY];
                weakenTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.PHYSICAL];
                bonusEffectTexturePaths = [
                    Weather.WeatherIconPaths[Weather.Types.RAINY],
                    Weather.WeatherIconPaths[Weather.Types.HOT]
                ];
            Mood.Types.GRUMPY:
                improveTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.PHYSICAL];
                weakenTexturePath = Stats.PrimaryStatIconPaths[Stats.Types.CRAFT];
                bonusEffectTexturePaths = [
                    Weather.WeatherIconPaths[Weather.Types.HOT],
                    Weather.WeatherIconPaths[Weather.Types.CLOUDY]
                ];
            Mood.Types.MOTIVATED:
                improveTexturePath = "all";
                weakenTexturePath = "";
                bonusEffectTexturePaths = [];
        
    if improveTexturePath:
        if improveTexturePath == "all":
            improveTexture.hide()
            improveLabel.text = "ALL";
            improveLabel.show()
        else:
            improveTexture.texture = load(improveTexturePath)
            improveTexture.show()
            improveLabel.hide()
    else:
        improveTexture.hide()
        improveLabel.text = "NONE"
        improveLabel.show()
    
    if weakenTexturePath:
        if weakenTexturePath == "all":
            weakenTexture.hide()
            weakenLabel.text = "ALL";
            weakenLabel.show()
        else:
            weakenLabel.hide()
            weakenTexture.show()
            weakenTexture.texture = load(weakenTexturePath)
    else:
        weakenTexture.hide()
        weakenLabel.text = "NONE"
        weakenLabel.show()
    

    for i in bonusEffectTextures.size():
        if i < bonusEffectTexturePaths.size():
            bonusEffectTextures[i].show();
            bonusEffectTextures[i].texture = load(bonusEffectTexturePaths[i]);
        else:
            bonusEffectTextures[i].hide();
    
    if bonusEffectTexturePaths.is_empty():
        bonusEffectLabel.show();
        bonusEffectLabel.text = "NONE";
    else:
        bonusEffectLabel.hide();
