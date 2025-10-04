# Tweening Animation
Check equip-crawl for lots of varied examples & reuse. 

Also have pretty hefty usage keys & kingdom and Tusk

Big considerations:
* Don't forget to set an "anchor point" for tweening based animations, especially "shake" type ones
* Don't let multiple tweens try to act on the same value - things get wonky.
* There was some system I did for a game - maybe equip crawl? - to make multiple tweens on the same
  property cancel out the older one. For that strategy, there was a different dedicated tween for
  each "layer" of animated behavior.
* Good for situations where we want some degree of randomness in the animation. If the behavior
  of the animation is static, consider using AnimationPlayer instead to make it easier to visualize
  and test.