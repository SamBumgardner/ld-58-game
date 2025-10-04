# Meter Display (and other HUD notes)
equip-crawl and TUSK have fancy health meters to reference.

Tusk also has good examples of numeric counters in the HUD that tick down over time. There should
also be implementation in packrat, but it might be a little more basic.

## Basic considerations
Usual pattern is the hud element will have a "display" value and an "actual" or "target" value.

The HUD element should be connected to some logical object that tracks the real value for gameplay
purposes. When that real value changes, the HUD object wants to observe the change ocurred. 

In response to the logical value changing, the HUD will:
* immediately change "target" value to match real value
* kick off a fresh tween (potentially cancelling any currently-running ones) to change the "display"
  value over time until it matches "target"