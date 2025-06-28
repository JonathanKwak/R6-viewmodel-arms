# R6 viewmodel arms
In a default ROBLOX game, your character's arms will not follow your camera like a first person shooter's viewmodel would. This script would solve that problem.

Here is the forum link for the original documentation:
https://devforum.roblox.com/t/r6-arms-as-viewmodels/1705291

This system was used by many of my other developer friends, and some have found their way on popular Roblox games (for instance, Combat Initiation).
This system does not represent how I code now. I'm constantly learning and improving, so this code was probably outdated by my standards at around 6 months old.

## Features

- Drag-and-drop compatibility (at least for Roblox games)
- Minimal setup required
- Procedurally generated walk animation when in first person
- Basic degree of configurability (walk cycle speed, arm transparency, etc)

## Setup

1. Open ROBLOX Studio
2. Open or create a game
3. Import onto the StarterGui or StarterPlayer service

## Design Notes

I decided to not use the conventional method of creating a separate viewmodel (that is, a model that contains just arms that is designed to be attached to the player camera) out of concern for compatibility and integration. In essence, I wanted this to be a simple drag-and-drop system that any game could implement with minimal effort, provided their game uses the R6 rig and has animations/effects done on the R6 rig.

The benefits of this approach is that you don't need to create a separate set of animations or models for the viewmodel. All the viewmodel rigging is derived directly from your character.

## Limitations

- Built for Roblox games only
- Not compatible with R15 rig types
