Config = {}

Config.ShameyDebug = true


-------- REBIRTH --------
Config.NaturalistRebirthSequence = {
	{
		fxName = "MP_NaturalistAnimalTransformStart",
		waitTime = 2000,
		fadeOut = true,
		fadeOutTime = 1800,
		waitAfterPlay = 1000,
	},
	{
		fxName = "skytl_0300_01clear",
		waitTime = 6000,
		fadeOut = true,
		fadeOutTime = 500,
		waitAfterPlay = 1200,
		letterbox = true,
	},
	{
		fxName = "Spirit_Coyote01_ODR3",
		waitTime = 15000,
		fadeOut = true,
		fadeOutTime = 500,
		waitAfterPlay = 2500,
		letterbox = true,
	},
	{
		fxName = "MP_NaturalistAnimalTransformEnd",
		waitTime = 20000,
		fadeOut = false,
		waitAfterPlay = 2000,
	},
}


-------- POTIONS --------
-- Handled in `rainbow-doctor`


-------- AMULETS --------
Config.AmuletAnimation = {
	PutOnAnimDict = "mech_inventory@clothing@bandana",
	PutOnAnimName = "satchel_2_neck",

	TakeOffAnimDict = "mech_inventory@clothing@bandana",
	TakeOffAnimName = "neck_2_satchel",
}

Config.AmuletNotifications = {
	AlreadyWearing = "You're already wearing an amulet.",
}

Config.MoneyAmulet = {
	ItemName = "amulet_money",

	UseNotification = "You put the amulet around your neck.",
	StopUseNotification = "You take the amulet off of your neck.",
	EffectNotification = "You notice an effect from your amulet.",
}

Config.StressAmulet = {
	ItemName = "amulet_energy",

	UseNotification = "You put the amulet around your neck.",
	StopUseNotification = "You take the amulet off of your neck.",
	EffectNotification = "You notice an effect from your amulet.",

	StressReductionAmount = 5,
	StressReductionWaitInSeconds = 10,
}

Config.AmuletRNG = {
	WaitInSeconds = 120, -- How long to wait for a "tick" to happen
	ChanceGive = 5, -- A "chance" of 5 means 1/5 chance it'll happen
	ChanceLargeUpperBound = 5,
	LargeUpperBound = 700,
	RegularUpperBound = 500,

	TimeRiskLossInMinutes = 120,
	TimeDefiniteLossInMinutes = 240,
	ChanceLoss = 20
}


-------- CRAFTING --------
Config.CraftLocations = {
	{
		name = "Naturalist Cauldron",
		id = "NaturalistCauldron",
		Job = { "naturalist" },
		x = 1294.49, y = 1177.55, z = 149.41,
		Categories = {"items"},
		ShowOnlyLocationCraftables = true,
	},
}

Config.Craftables = {
	-------- GRADE 1
	{
		UID = "potion_naturalist",
		Text = "Naturalist Potion",
		SubText = "InvMax = 1",
		Desc = "Recipe: 1x Earth Star, 1x Fire Rose, 1x Palm Dew, 1x Wind Lily",
		Items = {
			{
				name = "earth_star",
				count = 1
			},
			{
				name = "fire_rose",
				count = 1
			},
			{
				name = "palm_dew",
				count = 1
			},
			{
				name = "wind_lily",
				count = 1
			},
		},
		Reward = {
			{
				name = "potion_naturalist",
				count = 1
			}
		},
		Type = "item",
		JobMatrix = {
			{
				job = "naturalist",
				jobGrade = 1,
			},
		},
		Location = { "NaturalistCauldron" }, 
		UseCurrencyMode = false,
		CurrencyType = 0,
		CostToCraft = 1000,
		Category = "items",
		Animation = "craft",
	},

	-------- GRADE 2
	{
		UID = "amulet_energy",
		Text = "Energy Amulet",
		SubText = "InvMax = 1",
		Desc = "Recipe: 1x Copper, 1x Iron, 1x Lavender",
		Items = {
			{
				name = "copper",
				count = 1
			},
			{
				name = "iron",
				count = 1
			},
			{
				name = "Lavender",
				count = 1
			},
		},
		Reward = {
			{
				name = "amulet_energy",
				count = 1
			}
		},
		Type = "item",
		JobMatrix = {
			{
				job = "naturalist",
				jobGrade = 2,
			},
		},
		Location = { "NaturalistCauldron" }, 
		UseCurrencyMode = false,
		CurrencyType = 0, 
		Category = "items",
		Animation = 'craft'
	},
	{
		UID = "amulet_money",
		Text = "Money Amulet",
		SubText = "InvMax = 1",
		Desc = "Recipe: 1x Emerald, 1x Iron, 1x Desert Sage",
		Items = {
			{
				name = "emerald",
				count = 1
			},
			{
				name = "iron",
				count = 1
			},
			{
				name = "consumable_herb_desert_sage",
				count = 1
			},
		},
		Reward = {
			{
				name = "amulet_money",
				count = 1
			}
		},
		Type = "item",
		JobMatrix = {
			{
				job = "naturalist",
				jobGrade = 2,
			},
		},
		Location = { "NaturalistCauldron" }, 
		UseCurrencyMode = false,
		CurrencyType = 0, 
		Category = "items",
		Animation = 'craft'
	},
	{
		UID = "potion_healing",
		Text = "Healing Potion",
		SubText = "InvMax = 10",
		Desc = "Recipe: 1x Yarrow, 1x Water, 1x Honey",
		Items = {
			{
				name = "Yarrow",
				count = 1
			},
			{
				name = "water",
				count = 1
			},
			{
				name = "honey",
				count = 1
			},
		},
		Reward = {
			{
				name = "potion_healing",
				count = 1
			}
		},
		Type = "item",
		JobMatrix = {
			{
				job = "naturalist",
				jobGrade = 2,
			},
		},
		Location = { "NaturalistCauldron" }, 
		UseCurrencyMode = false,
		CurrencyType = 0, 
		Category = "items",
		Animation = 'craft'
	},
	{
		UID = "balm_healing",
		Text = "Healing Balm",
		SubText = "InvMax = 20",
		Desc = "Recipe: 1x Desert Sage, 1x Sap, 1x Honey, 1x Rubber",
		Items = {
			{
				name = "consumable_herb_desert_sage",
				count = 1
			},
			{
				name = "sap",
				count = 1
			},
			{
				name = "honey",
				count = 1
			},
			{
				name = "rubber",
				count = 1
			},	
		},
		Reward = {
			{
				name = "balm_healing",
				count = 1
			}
		},
		Type = "item",
		JobMatrix = {
			{
				job = "naturalist",
				jobGrade = 2,
			},
		},
		Location = { "NaturalistCauldron" }, 
		UseCurrencyMode = false,
		CurrencyType = 0, 
		Category = "items",
		Animation = 'craft'
	},
}