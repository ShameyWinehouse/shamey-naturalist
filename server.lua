local VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
    print = VORPutils.Print:initialize(print) --Initial setup 
end)
local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()



-- Register the usable items
Citizen.CreateThread(function()
	Wait(500)

	-- Naturalist Potion
	local naturalistPotionItemName = "potion_naturalist"
	VorpInv.RegisterUsableItem(naturalistPotionItemName, function(data)
		if Config.ShameyDebug then print("potion_naturalist used") end
		TriggerClientEvent("rainbow_naturalist:StartNaturalistPotionRebirth", data.source)
		TriggerEvent("vorpCore:subItem", data.source, naturalistPotionItemName, 1)
		VorpInv.CloseInv(data.source)
	end)

	-- Money Amulet
	VorpInv.RegisterUsableItem(Config.MoneyAmulet.ItemName, function(data)
		if Config.ShameyDebug then print("amulet money used") end
		TriggerClientEvent("rainbow_naturalist:ToggleAmuletMoney", data.source)
	end)

	-- Stress Amulet
	VorpInv.RegisterUsableItem(Config.StressAmulet.ItemName, function(data)
		if Config.ShameyDebug then print("amulet stress used") end
		TriggerClientEvent("rainbow_naturalist:ToggleAmuletStress", data.source)
	end)

	

end)

-- Register the craftables
Citizen.CreateThread(function ()

	Citizen.Wait(6000)

    for key, location in pairs(Config.CraftLocations) do
		-- if Config.ShameyDebug then print("CraftLocation: ", location) end
        TriggerEvent("vorp:AddCraftLocation", location)
    end

	for key, craftable in pairs(Config.Craftables) do
		-- if Config.ShameyDebug then print("CraftLocation: ", craftable) end
		TriggerEvent("vorp:AddRecipes", craftable)
    end

	if Config.ShameyDebug then print("registered crafting loc and recipes") end

end)



-------- EVENTS
-- 
RegisterServerEvent("rainbow_naturalist:UpgradeJobAfterRebirth")
AddEventHandler("rainbow_naturalist:UpgradeJobAfterRebirth", function(_source)
    local _source = source
	if Config.ShameyDebug then print("UpgradeJobAfterRebirth") end

	-- local Character = VORPcore.getUser(_source).getUsedCharacter
	-- Character.setJob("naturalist")
	-- Character.setJobGrade(2)

	-- TriggerClientEvent("vorp:TipRight", _source, "After rebirth, you have become a grade 2 Naturalist.", 10000)

end)

RegisterServerEvent("rainbow_naturalist:StressAmuletTick")
AddEventHandler("rainbow_naturalist:StressAmuletTick", function()
	local _source = source

	TickAmulet(_source, Config.StressAmulet.ItemName)
end)

RegisterServerEvent("rainbow_naturalist:MoneyAmuletTick")
AddEventHandler("rainbow_naturalist:MoneyAmuletTick", function()
	local _source = source

	local randBoolShouldGive = math.random(Config.AmuletRNG.ChanceGive)
	if Config.ShameyDebug then print("MoneyAmuletTick - randBoolShouldGive", randBoolShouldGive) end
	if randBoolShouldGive == 1 then
		GiveMoney(_source)
	end

	TickAmulet(_source, Config.MoneyAmulet.ItemName)
	
end)



-- 

RegisterServerEvent("rainbow_deliveries:LogOnDiscord")
AddEventHandler("rainbow_deliveries:LogOnDiscord", function(mission, deliveryTarget, completed, reasonString)
    -- local _source = source
	
	-- local User = VORPcore.getUser(_source)
	-- local Character = User.getUsedCharacter
	-- local stringTitle = "Delivery Mission "
	-- if completed == true then
	-- 	stringTitle = stringTitle.."Completed"
	-- else
	-- 	stringTitle = stringTitle.."Failed"
	-- end
	
	-- local messageString = string.format(
	-- 		"**Mission:** %s\n**Target:** %s\n**Character:** %s %s", 
	-- 		mission.name, deliveryTarget.label, Character.firstname, Character.lastname)
	-- if (not completed) and (reasonString and reasonString ~= '') then
	-- 	messageString = messageString .. string.format("\n**Failure Reason:** %s", reasonString)
	-- end
	
	-- VORPcore.AddWebhook(stringTitle, Config.Webhook, messageString)
end)


-------- FUNCTIONS

function GiveMoney(_source)
    -- local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter

	if Config.ShameyDebug then print("GiveMoney", _source) end

	-- Determine the upper bound
	local randLargeUpperBound = math.random(Config.AmuletRNG.ChanceLargeUpperBound)
	local upperBound
	if randLargeUpperBound == 1 then
		upperBound = Config.AmuletRNG.LargeUpperBound
	else
		upperBound = Config.AmuletRNG.RegularUpperBound
	end

	if Config.ShameyDebug then print("GiveMoney - upperBound", upperBound) end

	-- Determine the amount
	local rand = math.random(upperBound)
	local randMoney = rand / 100

	-- Round to 2nd decimal place
	local randMoneyRounded = round(randMoney, 2)

	if Config.ShameyDebug then print("GiveMoney - randMoney", randMoneyRounded) end

	-- Give and notify
	Character.addCurrency(0, randMoneyRounded)
	TriggerClientEvent("vorp:TipRight", _source, string.format("Your neck tingles. $%.02f appears in your pocket.", randMoneyRounded), 6000)

end

function TickAmulet(_source, itemName)

	-- Get the item
	local item = VorpInv.getItem(_source, itemName)
	if not item then
		print("ERROR: Could not find amulet item: ", itemName, _source)
		return
	end

	if Config.ShameyDebug then print("TickAmulet - item", item) end
	local metadata = item.metadata

	-- Get the ticks
	local ticks
	if metadata and metadata.ticks then
		ticks = tonumber(metadata.ticks)
	end

	if ticks and ticks >= 0 then
		-- Check if we're at the maximum time
		local timeWornInSeconds = metadata.ticks * Config.AmuletRNG.WaitInSeconds
		local timeWornInMinutes = timeWornInSeconds / 60
		if Config.ShameyDebug then print("TickAmulet - timeWornInMinutes", timeWornInMinutes) end
		if timeWornInMinutes >= Config.AmuletRNG.TimeDefiniteLossInMinutes then
			if Config.ShameyDebug then print("TickAmulet - TimeDefiniteLossInMinutes") end
			LoseAmulet(_source, itemName)
			return
		elseif timeWornInMinutes >= Config.AmuletRNG.TimeRiskLossInMinutes then
			local rand = math.random(Config.AmuletRNG.ChanceLoss)
			if Config.ShameyDebug then print("TickAmulet - TimeRiskLossInMinutes-rand", rand) end
			if rand == 1 then
				LoseAmulet(_source, itemName)
				return
			end
		end
	end


	-- Increment the tick
	if not metadata or not metadata.ticks or not ticks or ticks <= 0 then
		ticks = 1
	elseif ticks > 0 then
		ticks = ticks + 1
	end

	metadata.ticks = ticks

	VorpInv.setItemMetadata(_source, item.id, metadata)
	if Config.ShameyDebug then print("TickAmulet - metadata", metadata) end

end

function LoseAmulet(_source, itemName)
	if Config.ShameyDebug then print("LoseAmulet", _source, itemName) end
	TriggerEvent("vorpCore:subItem", _source, itemName, 1)
	TriggerClientEvent("vorp:TipRight", _source, "Your amulet has mysteriously disappeared.", 10000)

	if itemName == Config.MoneyAmulet.ItemName then
		TriggerClientEvent("rainbow_naturalist:StopAmuletMoney", _source, false)
	elseif itemName == Config.StressAmulet.ItemName then
		TriggerClientEvent("rainbow_naturalist:StopAmuletStress", _source, false)
	end
end

function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end




--------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

end)