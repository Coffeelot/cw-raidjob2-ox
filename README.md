# Raidjob 2 for OX
> This variant of Raidjob2 is ONLY for if you're using Ox lib and inventory. Works better for Ox than the normal Raidjob2, but lacks QB-inv support entirely, and requires oxlib

A QB based script that is more of a system than a plug and play job script. To utilize this script to it's fullest you need to be able to at least do some Config devving, if that's to much then go find another script ✌ This script comes with several npcs and pre made locations and jobs to do, but the idea of it is for YOU to create your own jobs! The Config comes full off comments to guide you.

**By default you can find ALL the mission givers on a rooftop at: `-905.68, -360.94, 130.28`** Make sure you move them 🔧

Raidjob 2, much like Raidjob 1, sets up PVE raids. This time it also makes use of [Renewed Phone groups](https://github.com/Renewed-Scripts/qb-phone) (optional toggle in Config) for better team interaction. The goal is simple:
1. Pay for the setup
2. Head to the location
3. Shoot the enemies
4. Grab the key
5. Grab the case
6. Wait for the timer on the case to go down (tracker is active for police during this time)
7. Open case from inventory
8. Return the content to the mission giver

The best way to describe Raidjob 2 compared to 1 is that it's a lot less Wallmart Heist and a lot more in the style of a job system. The focus in Raidjob 2 has been to be able to have multiple locations and have access to them controlled in an easy way. So low Tier might be easy to start, just a chunk of pocket change and you're good to go, while you might lock medium tier behind a Rep or a token.
If you used BoostJob, the way the missions are given is more like that, as compared to Raidjob 1, but each tier will have a different NPC.

Biggest differences:
- The missions are now tiered (low, mid and high by default. You can create whatever tiers you want in the config)
- Each tier has a set of locations, when the mission is started it randomizes between these.
- Each tier has one mission giver
- The location of the case is always random
- The key is not given when starting no more, you have to find the enemy that was holding it and loot them (using Target)
- Groups, using renewed phone.
This means the script lets all members of the group trigger stuff, not just the mission taker. Anyone can turn in the goods, but the payout only goes to the one that turns it it, and the buy in is paid by the one that starts it. There will be NO added auto-split  deal with it.
- Intergration with mz-skills for rep
- Enemies are spawned serverside, so should sync better... hopefully

Oh! And drop into the CW Discord and share your locations, and maybe pick up other players locations in the `#raidjob2-location-sharing` channel!

This also means raidjob(1) will be fully unsupported, and have reached it's End Of Life. No more patches, fixes or support will come to the current script.

[Raidjob 1](https://github.com/Coffeelot/cw-raidjob)
[Raidjob 2 - for non-ox](https://github.com/Coffeelot/cw-raidjob2)


# Preview 📽
## Showcase
[![YOUTUBE VIDEO](http://img.youtube.com/vi/ZBJHE9NxEnY/0.jpg)](https://youtu.be/ZBJHE9NxEnY)
## Job Creation Showcase
[![YOUTUBE VIDEO](http://img.youtube.com/vi/tgw2OtYF9B0/0.jpg)](https://youtu.be/tgw2OtYF9B0)

# Developed by Coffeelot and Wuggie -- Converted to Ox by Khatrie
[Tebex](https://cw-scripts.tebex.io/category/2523396) 👈\
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
[Support, updates and script previews](https://discord.gg/FJY4mtjaKr) 👈

# SETUP ❗
If you are using Renewed-Phone and want to use groups make sure `Config.UseRenewedPhoneGroups = true` Is set to true. (Cannot guarantee proper usage if this is set to false, but it is there.)

## ADD ITEMS 📦

Items to add to ox_inventory>data>items.lua
```
	-- RAIDJOB2
	['cw_raidjob_key'] = {
		label = 'Case key',
		weight = 0,
		stack = true,
		close = true,
		allowArmed = true,
		description = "Probably used for a case"
	},
	['cw_raidjob_case'] = {
		label = 'Case',
		weight = 0,
		stack = true,
		close = true,
		allowArmed = true,
		description = "Probably contains things"
	},
	['cw_raidjob_content'] = {
		label = 'Documents',
		weight = 0,
		stack = true,
		close = true,
		allowArmed = true,
		description = "Well above your paygrade"
	},

```
# Dependencies

* ox_lib - https://github.com/overextended/ox_lib
* PS-UI - https://github.com/Project-Sloth/ps-ui/
