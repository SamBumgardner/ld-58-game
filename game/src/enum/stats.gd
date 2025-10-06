class_name Stats

enum Types {
    STUDY = 0,
    PHYSICAL = 1,
    CRAFT = 2,
}
static var MajorEnums: Array[Dictionary] = [
    Study,
    Physical,
    Craft
]

enum Substats {
    WIT = 0,
    KNOWLEDGE = 1,
    MAGIC = 2,
    STRENGTH = 0,
    COURAGE = 1,
    ENDURANCE = 2,
    CREATION = 0,
    PRECISION = 1,
    PLANNING = 2,
}

enum Study {
    WIT = 0,
    KNOWLEDGE = 1,
    MAGIC = 2,
}
static var StudyNames: Array[String] = [
    "Wit",
    "Knowledge",
    "Magic"
]
static var StudyPaths: Array[String] = [
    "res://assets/art/substats/substat_wit.png",
    "res://assets/art/substats/substat_knowledge.png",
    "res://assets/art/substats/substat_magic.png"
]

enum Physical {
    STRENGTH = 0,
    COURAGE = 1,
    ENDURANCE = 2,
}
static var PhysicalNames: Array[String] = [
    "Strength",
    "Courage",
    "Endurance"
]
static var PhysicalPaths: Array[String] = [
    "res://assets/art/substats/substat_strength.png",
    "res://assets/art/substats/substat_courage.png",
    "res://assets/art/substats/substat_endurance.png"
]

enum Craft {
    CREATION = 0,
    PRECISION = 1,
    PLANNING = 2,
}
static var CraftNames: Array[String] = [
    "Creation",
    "Precision",
    "Planning"
]
static var CraftPaths: Array[String] = [
    "res://assets/art/substats/substat_creation.png",
    "res://assets/art/substats/substat_precision.png",
    "res://assets/art/substats/substat_planning.png"
]

static var NamesLookup: Array[Array] = [
    StudyNames,
    PhysicalNames,
    CraftNames,
]
static var PathsLookup: Array[Array] = [
    StudyPaths,
    PhysicalPaths,
    CraftPaths,
]

static func getNameForSubstat(statType: Types, substatIndex: int) -> Array[String]:
    return NamesLookup[statType][substatIndex];

static var PrimaryStatIconPaths: Array[String] = [
    "res://assets/art/stat_study.png",
    "res://assets/art/stat_physical.png",
    "res://assets/art/stat_craft.png"
]
