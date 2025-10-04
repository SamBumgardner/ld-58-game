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
