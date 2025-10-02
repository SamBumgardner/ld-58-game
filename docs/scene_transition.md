# Scene Transition Handling
Some notes about past projects to reference for hacking stuff together.

### Basics: Global Database & Direct Transition
This has been done in a few projects, loading a "database" as a singleton that is accessible as the game transitions between scenes.

This works pretty well for smaller projects but can lead to some headaches as state grows more complex. Just throwing everything into a flat structure (what is usually easiest at the time of implementation) makes resetting state tricky. 

More serious problems can arise if the ownership of these shared fields becomes murky. Which piece of code was responsible for touching field `x` again? Or which one ended up touching it last?

Tusk used this, though it became fairly messy by the end. Heroes of Keys & Kingdom did too, probably stayed cleaner due to reduced scope.

### Pass Transition Data
See equip-crawl for example of this. More responsibility on each scene, but it helps ensure you just retain the data you intended to retain.

Can be used for long-term progression & short-term communication betweeen states.

Important cost: must have some kind of parent scene observing current & next scene to hand-over the data.

## Executing Transitions

### No transitions
Jerky, doesn't always play nicely with music.

### Transition screen fade-in fade-out
See equip-crawl for an example of this. There's basically an interface that all scenes implement. Need to:
* implement method for wrapping up the scene: `_signal_transition_out()`, emits `start_transition_out`
* `start_transition_out` should include `TransitionData` and a `cleanup_callback` to run after everything is visually hidden.
* implement method for initializing scene from `TransitionData`: `init_scene`
* implment `start_scene` method, to be called by coordinating parent as the scene fades in.
