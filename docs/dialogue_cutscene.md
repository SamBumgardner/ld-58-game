# Dialogue Cutscene Notes
Just some reminders for myself about how my plugin was intended to be used, since it's been a while.

## Assets Required:
For each character:
* Sprite sheet of expression images. Aim for between 1/4 & 1/3 of screen width.
    * If doing an animated mouth, make sure to not include it in the expressions.
    * Have one expression animation named `"default"`.
    * Can have more animations, name them to match the tags used in dialogue cutscenes.
* Sprite sheet of mouth images. 
    * Size should match the expression images for convenience - just export as a separate layer.
    * Can have sequences of images, should be labelled in sprite sheet with names corresponding to usage.
    * Spritesheet animation squences must include `"default"` and `"talking"`
* Sound

Needed in general:
* Dialogue box
* Arrow

## Dialogue Script Specification
See `DialogueCutsceneData.gd` and `DialogueUnit.gd` for documentation.

Example script file

```
!characters
Gerald
Cameron

!script
    Cameron:
|1.5|So, do you want to talk about anything in particular?

We've got all of this space to work with, after all.|

    Gerald:
|1|I think I'd like to talk about boats today.|

    Cameron:
|1.5|Boats, huh? I've never had one before. I hear they can be pretty expensive to maintain.|

    Gerald:
|1,0,2|Yeah, me neither.|.15,0,0,default,default|...|

    Cameron:
|1.5,0,.5,worried|Wait, that's it?|1.5,0,0,curious| Why did you even bring them up in the first place?|

    Gerald:
|1,0,.5|I just wanted to see how long we could keep this conversation |1.5,1,.5,laughing,talking,smile|AFLOAT!|

    Cameron:
|1.5,0,0,worried,talking,smile|Boooooooo!|
```

Quick notes:
* Lead with `!characters` section. NAmes here should directly correspond to the name of a `DialogueCharacter` resource
* `!Script` section needs general structure of `<character_name>:|metadata|dialogue|`
* metadata info is comma-separated, corresponding to the parameters:
    * `speed_mult` - rate dialogue is displayed to the screen
    * `delay_before` - pause (in seconds) before next dialogue chunk plays
    * `delay_after` - pause (in sceonds) after next dialogue chunk plays
    * `expression_animation` - animation name from sprite sheet to play for the "expression" part of character (everything but mouth)
    * `talking_animation` - animation name from mouth sprite sheet to play while text is being displayed
    * `resting_animation` - animation name from mouth sprite sheet to play during gaps in text playing
* metadata default values are:
    * speed_mult = 1
    * delay_before = 0
    * delay_after = 0
    * expression_name = "default"
    * talking_animation = "talking"
    * resting_animation = "default"

## Incorporating Dialogue Cutscene into a scene.
See `SampleGameplay.tscn` from the godot-4-dialogue-cutscene project.

Creating a canvas layer separate from other gameplay is the right idea. Keep the `CutsceneLayer` hidden,
and give it a `DialogueCutscene` child scene.

Loading the 9-patch rectangles for the `DialogueCutscene` was apparently a little messy. See the 
example scene for a strategy to work around it.

Steps to take:
* `connect` `DialogueCutscene.custcene_finished` to an appropriate action in parent scene.
* Call `DialogueCutscene.set_graphic_overrides` to set up 9-patch graphics & arrow
* Make sure the cutscene files (`.dc` extension) are imported w/ config pointed at directory with 
  `DialogueCharacter` resources
* Make sure `DialogueCharacter` resources are named `DialogueCharacter_<characterName>.tres`