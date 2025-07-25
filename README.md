# shamey-naturalist

A free, open-source RedM script for witches and amulets

Our server had a "naturalist" job but it wasn't the RDR concept of naturalist; they were more like witches.

I'm uploading this script more as a reference for writing your own scripts than as a product that can be used off-the-shelf, since this script was tightly integrated to many other scripts and customizations.

## Features
- AMULETS
  - Amulet items that can be "worn" for passive bonuses
  - **Stress Amulet** reduces stress (see `shamey-stress`)
  - **Money Amulet** gives a chance to randomly receive an amount of money
  - Amulets disappear after a time bracket
- Timed cinematic "rebirth" cutscene
- Highly configurable (amulet strength, amulet intervals and thresholds, cutscene sequence, notifications, animations)
- Organized & documented
- Performant

## Configuration
For `Config.AmuletRNG` in `config.lua`, the following example settings:
```
Config.AmuletRNG = {
	WaitInSeconds = 120, -- How long to wait for a "tick" to happen
	ChanceGive = 5, -- A "chance" of 5 means 1/5 chance it'll happen
	ChanceLargeUpperBound = 7,
	LargeUpperBound = 700,
	RegularUpperBound = 500,

	TimeRiskLossInMinutes = 120,
	TimeDefiniteLossInMinutes = 240,
	ChanceLoss = 20
}
```
...mean that, when the amulet is being "worn", every 120 seconds (`WaitInSeconds`) an amulet "tick" will happen. When each amulet "tick" happens, there will be a 20% chance (`ChanceGive`) that the wearer will receive money. If they're lucky enough to get money, the amount will be random between $1 and $500 (`RegularUpperBound`). However, there is a 7% chance (`ChanceLargeUpperBound`) that the upper bound will actually be higher at $700 (`LargeUpperBound`).

Additionally, the amulet won't disappear until after 120 minutes (`TimeRiskLossInMinutes`) total have passed. Once that time has passed, there will start being a 20% chance (`ChanceLoss`) per tick that the amulet will disappear. If 240 minutes (`TimeDefiniteLossInMinutes`) pass and the amulet still hasn't disappeared, then it finally will (like a hard cap).

## Requirements
- [VORP Framework](https://github.com/vorpcore)

## License & Support
This software was formerly proprietary to Rainbow Railroad Roleplay, but I am now releasing it free and open-source under GNU GPLv3. I cannot provide any support.
