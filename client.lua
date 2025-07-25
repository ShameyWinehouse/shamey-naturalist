local VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
    print = VORPutils.Print:initialize(print) --Initial setup 
end)
local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)
MenuData = {}
TriggerEvent("menuapi:getData",function(call)
    MenuData = call
end)


local isWearingAmulet = false
local isWearingAmuletMoney = false
local isWearingAmuletStress = false


-------- THREADS




-------- EVENTS

RegisterNetEvent("rainbow_naturalist:StartNaturalistPotionRebirth")
AddEventHandler("rainbow_naturalist:StartNaturalistPotionRebirth", function()
	if Config.ShameyDebug then print("StartNaturalistPotionRebirth") end

	Citizen.Wait(1000)

	playMusicEvent("MP_SPIRIT_ANIMAL_START")

	Citizen.Wait(2000)

	-- Play the fx
	for key, fx in ipairs(Config.NaturalistRebirthSequence) do
		
		preloadFx(fx.fxName)

		AnimpostfxPlay(fx.fxName)

		Citizen.Wait(fx.waitAfterPlay)

		DoScreenFadeIn(500)

		if fx.letterbox then
			Citizen.InvokeNative(0x69D65E89FFD72313, true, true) -- RequestLetterBoxNow
			if Config.ShameyDebug then print("requested letterbox") end
		else
			Citizen.InvokeNative(0x69D65E89FFD72313, false, false) -- RequestLetterBoxNow
			Citizen.InvokeNative(0x69D65E89FFD72313, false, false) -- RequestLetterBoxNow
			if Config.ShameyDebug then print("NO** letterbox") end
		end

		if Config.ShameyDebug then print("played", fx.fxName) end

		-- Wait for the fx/scene to play fully
		Citizen.Wait(fx.waitTime)
			
		if fx.fadeOut then
			DoScreenFadeOut(fx.fadeOutTime)
			Citizen.Wait(fx.fadeOutTime)
		end

		AnimpostfxStop(fx.fxName)
		Citizen.InvokeNative(0xC5CB91D65852ED7E, fx.fxName) -- AnimpostfxClearEffect
		Citizen.InvokeNative(0x37D7BDBA89F13959, fx.fxName) -- AnimpostfxSetToUnload
		
		Citizen.Wait(500)
		
    end

	if not IsScreenFadedIn() then
		DoScreenFadeIn(500)
	end

	AnimpostfxStopAll()
	Citizen.InvokeNative(0x69D65E89FFD72313, false, false) -- RequestLetterBoxNow

	playMusicEvent("MP_SPIRIT_ANIMAL_STOP")

	--

	Citizen.Wait(2000)

	TriggerServerEvent("rainbow_naturalist:UpgradeJobAfterRebirth")
end)


RegisterNetEvent("rainbow_naturalist:ToggleAmuletMoney")
AddEventHandler("rainbow_naturalist:ToggleAmuletMoney", function()
	if Config.ShameyDebug then print("ToggleAmuletMoney") end

	-- Check if they're already using an amulet
	if isWearingAmulet then
		if isWearingAmuletMoney then
			TriggerEvent("rainbow_naturalist:StopAmuletMoney", true)
		else
			TriggerEvent("vorp:TipRight", Config.AmuletNotifications.AlreadyWearing, 6000)
		end
	else
		TriggerEvent("rainbow_naturalist:StartAmuletMoney")
	end

end)

RegisterNetEvent("rainbow_naturalist:ToggleAmuletStress")
AddEventHandler("rainbow_naturalist:ToggleAmuletStress", function()
	if Config.ShameyDebug then print("ToggleAmuletStress") end

	-- Check if they're already using an amulet
	if isWearingAmulet then
		if isWearingAmuletStress then
			TriggerEvent("rainbow_naturalist:StopAmuletStress", true)
		else
			TriggerEvent("vorp:TipRight", Config.AmuletNotifications.AlreadyWearing, 6000)
		end
	else
		TriggerEvent("rainbow_naturalist:StartAmuletStress")
	end

end)


RegisterNetEvent("rainbow_naturalist:StartAmuletMoney")
AddEventHandler("rainbow_naturalist:StartAmuletMoney", function()

	isWearingAmulet = true
	isWearingAmuletMoney = true

	TriggerEvent("vorp:Tip", Config.MoneyAmulet.UseNotification, 4000)
	PlayAnim(Config.AmuletAnimation.PutOnAnimDict, Config.AmuletAnimation.PutOnAnimName)
	Citizen.Wait(6 * 1000)

	Citizen.CreateThread(function()

		while isWearingAmulet and isWearingAmuletMoney do
			if Config.ShameyDebug then print("isWearingAmulet") end

			TriggerServerEvent("rainbow_naturalist:MoneyAmuletTick")

			Citizen.Wait(Config.AmuletRNG.WaitInSeconds * 1000)
		end
	end)

end)

RegisterNetEvent("rainbow_naturalist:StopAmuletMoney")
AddEventHandler("rainbow_naturalist:StopAmuletMoney", function(shouldPlayAnim)

	isWearingAmulet = false
	isWearingAmuletMoney = false

	if shouldPlayAnim then
		TriggerEvent("vorp:Tip", Config.MoneyAmulet.StopUseNotification, 4000)
		PlayAnim(Config.AmuletAnimation.TakeOffAnimDict, Config.AmuletAnimation.TakeOffAnimName)
	end

end)


RegisterNetEvent("rainbow_naturalist:StartAmuletStress")
AddEventHandler("rainbow_naturalist:StartAmuletStress", function()

	isWearingAmulet = true
	isWearingAmuletStress = true

	TriggerEvent("vorp:Tip", Config.StressAmulet.UseNotification, 4000)
	PlayAnim(Config.AmuletAnimation.PutOnAnimDict, Config.AmuletAnimation.PutOnAnimName)
	Citizen.Wait(6 * 1000)

	Citizen.CreateThread(function()

		while isWearingAmulet and isWearingAmuletStress do
			if Config.ShameyDebug then print("isWearingAmulet - stress") end

			if Config.Debug then print("RemoveStress") end
			TriggerEvent("vorp:RemoveStress", Config.StressAmulet.StressReductionAmount)

			Citizen.Wait(Config.StressAmulet.StressReductionWaitInSeconds * 1000)
		end
	end)

	Citizen.CreateThread(function()

		while isWearingAmulet and isWearingAmuletStress do

			TriggerServerEvent("rainbow_naturalist:StressAmuletTick")

			Citizen.Wait(Config.AmuletRNG.WaitInSeconds * 1000)
		end
	end)

end)

RegisterNetEvent("rainbow_naturalist:StopAmuletStress")
AddEventHandler("rainbow_naturalist:StopAmuletStress", function(shouldPlayAnim)

	isWearingAmulet = false
	isWearingAmuletStress = false

	if shouldPlayAnim then
		TriggerEvent("vorp:Tip", Config.StressAmulet.StopUseNotification, 4000)
		PlayAnim(Config.AmuletAnimation.TakeOffAnimDict, Config.AmuletAnimation.TakeOffAnimName)
	end

end)


--------


-- if Config.ShameyDebug then
	-- RegisterCommand("debugSetInnerHealth", function(source, args, rawCommand)
		-- if Config.ShameyDebug then print("debugSetInnerHealth") end
		-- local _source = source
		-- SetInnerCoreHealth(tonumber(args[1]))
	-- end)
	-- RegisterCommand("debugSetOuterHealth", function(source, args, rawCommand)
		-- if Config.ShameyDebug then print("debugSetOuterHealth") end
		-- local _source = source
		-- SetOuterCoreHealth(tonumber(args[1]))
	-- end)
	-- RegisterCommand("debugSetStamina", function(source, args, rawCommand)
		-- if Config.ShameyDebug then print("debugSetStamina") end
		-- local _source = source
		-- SetStamina(tonumber(args[1]))
	-- end)
-- end


-------- FUNCTIONS

function preloadFx(fxName)
	Citizen.InvokeNative(0x5199405EABFBD7F0, fxName) -- AnimpostfxPreloadPostfx
	Citizen.Wait(100)
end

function playMusicEvent(name)
	Citizen.InvokeNative(0x1E5185B72EF5158A, name)  -- PREPARE_MUSIC_EVENT
	Citizen.InvokeNative(0x706D57B0F50DA710, name)  -- TRIGGER_MUSIC_EVENT
end

function PlayAnim(animDict, animName)
	if Config.ShameyDebug then print("PlayAnim") end

	-- Unarm the player so the weapon doesn't interfere
	Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true) -- HidePedWeapons

	-- Play the animation
	RequestAnimDict(animDict)
	while (not HasAnimDictLoaded(animDict)) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, 1.0, 3000, 1, 1.0, false, false, false)
	Citizen.Wait(3000)
	ClearPedTasks(PlayerPedId())
end

function SetInnerCoreHealth(newHealth)
	newHealth = math.floor(newHealth)
	if Config.ShameyDebug then print("SetInnerCoreHealth", newHealth) end
	Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newHealth) -- SetAttributeCoreValue native
end

function SetOuterCoreHealth(newHealth)
	newHealth = math.floor(newHealth)
	if Config.ShameyDebug then print("SetOuterCoreHealth", newHealth) end
	SetEntityHealth(PlayerPedId(), newHealth, 0)
end

function SetStamina(newStamina)
	newStamina = math.floor(newStamina)
	if Config.ShameyDebug then print("SetStamina", newStamina) end
	Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) -- SetAttributeCoreValue native
end

function LogOnDiscord(mission, completed, reasonString)
	-- print("LogOnDiscord", completed, reasonString)
	-- TriggerServerEvent("rainbow_deliveries:LogOnDiscord", mission, deliveryTarget, completed, reasonString)
end
  


--------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	local isWearingAmulet = false
	local isWearingAmuletMoney = false
	local isWearingAmuletStress = false

	ClearPedTasks(PlayerPedId())

end)
