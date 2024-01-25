local QBCore = exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug

local isLoggedIn = LocalPlayer.state['isLoggedIn']
local PlayerJob = nil
local CurrentCops = 0
local PlayerPopGroup = 'RaidPlayerGroup'
local GuardPopGroup = 'RaidGuardGroup'
local CivPopGroup = 'RaidCivGroup'

local CurrentJob = {
    jobDiff = nil,
    jobId = nil,
    jobLocationName = nil,
    case = nil,
    pedThatHasKey = nil,
    caseIsUnlocked = false,
    keyTaken = false
}
local onRun = false

local blipCircle = nil
local BossEntities = {}
local Entities = {}
local vehicleBlip = nil
local policeBlip = nil
local deliveryBlip = nil

local PlayerGroup = {}

local npcs = {
    ['npcguards'] = {},
    ['npccivilians'] = {}
}

local npcVehicles = {}

local function cancelEmote()
    TriggerEvent('animations:client:EmoteCommandStart', {'c'})
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    if useDebug then
        print('updating police count in raidjob:', amount)
    end
    CurrentCops = amount
end)

local function checkSkills(diff)
    if Config.UseMZSkills and Config.Jobs[diff].minLimit then
        return exports["mz-skills"]:GetCurrentSkill(Config.Skill).Current >= Config.Jobs[diff].minLimit
    else
        return true
    end
end

local function checkCops(diff)
    if useDebug then
       print('CurrentCops:' ,CurrentCops)
       print('Cop Req:' ,Config.Jobs[diff].minimumPolice)
       print('Has enough cops:',Config.Jobs[diff].minimumPolice <= CurrentCops )
    end
    return Config.Jobs[diff].minimumPolice <= CurrentCops
end

local function getAllContent(object, diff)
    local content = {}
    local PlayerData = QBCore.Functions.GetPlayerData()
    for i,item in pairs(PlayerData.items) do
        if item.name == object then
            content[item.info.diff] = item
        end
    end
    return content
end

local function hasContent(object, diff)
    local items = exports.ox_inventory:Search('count', object , { diff = diff } )
    if useDebug then print('Has loot to drop off:', items>0 ) end
    return items > 0
end

local function canInteract(diff)
    if onRun then return false end
    local hasSkills = checkSkills(diff)
    local hasToken = true
    local hasCops = checkCops(diff)
    if Config.UseTokens and Config.Jobs[diff].token ~= nil then
        local tokens = nil
        hasToken = exports['cw-tokens']:hasToken(Config.Jobs[diff].token)
    end

    if useDebug then 
        print('Interact check:')
        print('has skills:', hasSkills)
        print('has token:', hasToken)
        print('hasCops', hasCops)
    end
    return hasSkills and hasToken and hasCops
end

--- Create bosses
CreateThread(function()
    for diff, job in pairs(Config.Jobs) do
        local animation
        if job.Boss.animation then
            animation = job.Boss.animation
        else
            animation = "WORLD_HUMAN_STAND_IMPATIENT"
        end
        QBCore.Functions.LoadModel(job.Boss.model)
        local currentBoss = CreatePed(0, job.Boss.model, job.Boss.coords.x, job.Boss.coords.y, job.Boss.coords.z-1.0, job.Boss.coords.w, false, false)
        BossEntities[#BossEntities+1] = currentBoss
        TaskStartScenarioInPlace(currentBoss,  animation)
        FreezeEntityPosition(currentBoss, true)
        SetEntityInvincible(currentBoss, true)
        SetBlockingOfNonTemporaryEvents(currentBoss, true)

        local options = {
            {
                type = "client",
                event = "cw-raidjob2:client:attemptStart",
                diff = diff,
                icon = job.icon,
                label = Config.Jobs[diff].description,
                distance = 2.5,
                canInteract = function()
                    if not Config.Enabled then return false end
                    return canInteract(diff)
                end
            },
            {
                type = "client",
                event = "cw-raidjob2:client:cancelJob",
                icon = "fas fa-times",
                label = Lang:t('info.cancel_job'),
                distance = 2.5,
                canInteract = function()
                    if not Config.Enabled then return false end
                    return onRun
                end
            },
            {
                type = "client",
                event = "cw-raidjob2:client:turnInGoods",
                diff = diff,
                icon = 'fas fa-hand-holding-usd',
                label = Lang:t('info.turn_in_goods'),
                distance = 2.5,
                canInteract = function()
                    if not Config.Enabled then return false end
                    return canInteract(diff) and hasContent(Config.Items.caseContent, diff)
                end
            }
        }
        exports.ox_target:addLocalEntity(currentBoss, options)
    end
end)

RegisterNetEvent('cw-raidjob2:client:cancelJob', function(data)
    TriggerEvent('animations:client:EmoteCommandStart', {"idle11"})
    QBCore.Functions.Progressbar("getting_reward", Lang:t('info.canceling_job'), Config.BossTalkTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('cw-raidjob2:server:cancelJob', CurrentJob.jobId)
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
    end)
end)

RegisterNetEvent('cw-raidjob2:client:turnInGoods', function(data)
    local diff = data.diff
    if useDebug then
        print('Getting reward for job with diff',diff)
    end

    TriggerEvent('animations:client:EmoteCommandStart', {"idle11"})
    QBCore.Functions.Progressbar("getting_reward", Lang:t('info.talking_to_boss'), Config.BossTalkTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('cw-raidjob2:server:givePayout', diff)
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
    end)
end)

local function CleanUp()
    for i, entity in pairs(Entities) do
        print('deleting', entity)
        if DoesEntityExist(entity) then
           DeleteEntity(entity)
        end
    end
end

---Phone msgs
local function RunStart()
	Citizen.Wait(2000)

    local sender = Lang:t('mailstart.sender')
    local subject = Lang:t('mailstart.subject')
    local message = Lang:t('mailstart.message')

    if Config.Jobs[CurrentJob.jobDiff].Messages then
        if Config.Jobs[CurrentJob.jobDiff].Messages.Start.sender then
            sender = Config.Jobs[CurrentJob.jobDiff].Messages.Start.sender
        end
        if Config.Jobs[CurrentJob.jobDiff].Messages.Start.subject then
            subject = Config.Jobs[CurrentJob.jobDiff].Messages.Start.subject
        end
        if Config.Jobs[CurrentJob.jobDiff].Messages.Start.message then
            message = Config.Jobs[CurrentJob.jobDiff].Messages.Start.message
        end
    end

        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = sender,
            subject = subject,
            message = message,
        })

	Citizen.Wait(3000)
end

local function resetJob ()
    CurrentJob = {}
    onRun = false
end

local function CaseOpenMessages()
    Citizen.Wait(2000)
    local sender = Lang:t('mailEnd.sender')
	local subject = Lang:t('mailEnd.subject')
	local message = Lang:t('mailEnd.message')

    if Config.Jobs[CurrentJob.jobDiff].Messages then
        if Config.Jobs[CurrentJob.jobDiff].Messages.Finish then
            if Config.Jobs[CurrentJob.jobDiff].Messages.Finish.sender then
                sender = Config.Jobs[CurrentJob.jobDiff].Messages.Finish.sender
            end
            if Config.Jobs[CurrentJob.jobDiff].Messages.Finish.subject then
                subject = Config.Jobs[CurrentJob.jobDiff].Messages.Finish.subject
            end
            if Config.Jobs[CurrentJob.jobDiff].Messages.Finish.message then
                message = Config.Jobs[CurrentJob.jobDiff].Messages.Finish.message
            end
        end
    end

	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
	    subject = subject,
	    message = message,
	})
end


local function caseGps()
    TriggerEvent('cw-raidjob2:client:theftCall')
    if QBCore.Functions.GetPlayerData().job.name == 'police' then
        policeBlip = AddBlipForEntity(PlayerPedId())
        SetBlipSprite(policeBlip, 161)
        SetBlipScale(policeBlip, 1.4)
        PulseBlip(policeBlip)
        SetBlipColour(policeBlip, 1)
        SetBlipAsShortRange(policeBlip, true)
    end
end

local function caseIsUnlockedMessage(diff)
    Citizen.Wait(2000)
    local sender =  ''
	local subject = ''
	local message = ''

    if Config.Jobs[diff].Messages.Finish then
        if Config.Jobs[diff].Messages.Finish.sender then
            sender = Config.Jobs[diff].Messages.Finish.sender
        end
        if Config.Jobs[diff].Messages.Finish.subject then
            subject = Config.Jobs[diff].Messages.Finish.subject
        end
        if Config.Jobs[diff].Messages.Finish.message then
            message = Config.Jobs[diff].Messages.Finish.message
        end
    end

	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
	    subject = subject,
	    message = message,
	})

    QBCore.Functions.Notify(Lang:t("success.contentAquired"), 'success')
end

local function caseAquiredMessage()
    caseGps()
    Citizen.Wait(1000)
    local sender = ''
	local subject = ''
	local message = ''

    if Config.Jobs[CurrentJob.jobDiff].Messages.Aquired then
        if Config.Jobs[CurrentJob.jobDiff].Messages.Aquired.sender then
            sender = Config.Jobs[CurrentJob.jobDiff].Messages.Aquired.sender
        end
        if Config.Jobs[CurrentJob.jobDiff].Messages.Aquired.subject then
            subject = Config.Jobs[CurrentJob.jobDiff].Messages.Aquired.subject
        end
        if Config.Jobs[CurrentJob.jobDiff].Messages.Aquired.message then
            message = Config.Jobs[CurrentJob.jobDiff].Messages.Aquired.message
        end
    end

	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
	    subject = subject,
	    message = message,
	})

    QBCore.Functions.Notify(Lang:t("success.caseAquired"), 'success')
    SetTimeout(Config.Jobs[CurrentJob.jobDiff].timer, function()
        RemoveBlip(policeBlip)
    end)
end
-- CASE


RegisterNetEvent('cw-raidjob2:client:spawnCase', function(networkId)

    CreateThread(function()

        local case = NetworkGetEntityFromNetworkId(networkId)
        while not DoesEntityExist(case) do
            Wait(1000)
            print("WAITING FOR CASE SPAWN", case, networkId)
        end
        local options = {
            {
            name = "SpawnCase-"..CurrentJob.jobId,
            label = Lang:t('info.unlock_first'),
            icon = "fas fa-key",
            distance = 2.5,
            event = 'cw-raidjob2:client:items',
            canInteract = function()
                return onRun and not CurrentJob.CaseIsInUse
            end
        },
        }
        exports.ox_target:addEntity(networkId, options)
    end)
end)


--- NPCs
local function setRelations(ped, guardGroupHash)
    SetRelationshipBetweenGroups(0, guardGroupHash, guardGroupHash)
    SetRelationshipBetweenGroups(5, guardGroupHash, GetPedRelationshipGroupHash(ped))
    SetRelationshipBetweenGroups(5,  GetPedRelationshipGroupHash(ped), guardGroupHash)
end

local keyOptions = {}

RegisterNetEvent('cw-raidjob2:client:setKeyTaken', function(keyHolder)
    if useDebug then
       print('Setting key taken')
    end
    exports.ox_target:removeEntity(keyHolder, keyOptions)
    CurrentJob.keyTaken = true
    CurrentJob.pedThatHasKey = nil
end)

local function giveKey(ped)
    CreateThread(function()
        local NPC = NetworkGetEntityFromNetworkId(ped)
        CurrentJob.keyTaken = false
        if useDebug then print("KEY IS SUPPOSED TO BE ON ", ped, "ENTITY ", NPC) end
        CurrentJob.pedThatHasKey = ped
        while not DoesEntityExist(NPC) do
            Wait(100)
        end

        keyOptions = {
            {
            name = "cwgivekey-"..CurrentJob.jobId,
            icon = 'magnifying-glass',
            label = Lang:t('info.search_key'),
            distance = 2.5,
            onSelect = function()
                CurrentJob.pedThatHasKey = nil
                TriggerServerEvent('cw-raidjob2:server:hasKeys', CurrentJob.jobId)
                local player = PlayerPedId()
                RequestAnimDict("pickup_object")
                while not HasAnimDictLoaded("pickup_object") do
                    Wait(0)
                end
                QBCore.Functions.Notify(Lang:t("info.picked_up_key"), 'success')
                TaskPlayAnim(player, "pickup_object", "pickup_low", 8.0, -8.0, -1, 1, 0, false, false, false)
                Wait(2000)
                ClearPedTasks(player)
            end,
            canInteract = function(entity)
                if IsEntityDead(entity) and not CurrentJob.keyTaken then
                    return true
                end
            end
            }
        }

        exports.ox_target:addEntity(ped, keyOptions)
    end)

end

local function setStats(ped, netid, stats)
    if useDebug then print("SETTING STATS FOR ", ped, netid) end
    SetEntityAsMissionEntity(ped)
    SetPedAccuracy(ped, stats.accuracy)
    SetPedCanSwitchWeapon(ped, true)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    if stats.hasKey then
        giveKey(netid)
    end
end

RegisterNetEvent('cw-raidjob2:client:setRelationsAndStats', function(npc, npcStats)
    local ped = PlayerPedId()
    local trash, guardGroupHash = AddRelationshipGroup(GuardPopGroup)
    if useDebug then
       print('created guard group has', guardGroupHash)
    end
    Wait(3000)
    for networkId, v in pairs(npc[GuardPopGroup]) do
        if useDebug then print("TRYING TO SET ", networkId) end
        local entity = NetworkGetEntityFromNetworkId(networkId)
        while not DoesEntityExist(entity) do
            Wait(1)
        end

        SetPedRelationshipGroupHash(entity, guardGroupHash)
        if useDebug then print(entity, networkId, npcStats[networkId]) end
        setStats(entity, networkId, npcStats[networkId])
        Entities[#Entities+1] = entity
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(entity, 10.0, 10.0, 1)
        end
    end
    setRelations(ped,guardGroupHash)
end)

RegisterNetEvent('cw-raidjob2:client:setVehicleEntities', function(vehicles)
    if useDebug then
       print('vehicles:', vehicles)
    end
    if vehicles then
        if useDebug then
           QBCore.Debug(vehicles)
        end
        for networkId, v in pairs(vehicles) do
            while not DoesEntityExist(NetworkGetEntityFromNetworkId(networkId)) do
                Wait(1000)
            end
            local entity = NetworkGetEntityFromNetworkId(networkId)
            Entities[#Entities+1] = entity
        end
    end
end)

-- Distance check loop
local function checkDistance()
    CreateThread(function()
        while true do
            if not onRun then break end
            if CurrentJob.enemisHaveBeenSpawned == true then break end

            local ped = PlayerPedId()            -- get local ped
            local plyCoords = GetEntityCoords(ped, 0)
            local location = Config.Locations[CurrentJob.jobDiff][CurrentJob.jobLocationName].coords
            local distance = #(plyCoords.xy-location.xy)
            --if useDebug then
            --    print('distance', distance)
            --end

            if(distance < Config.SpawnDistance) then
                if useDebug then print('spawning enemies') end
                    TriggerServerEvent('cw-raidjob2:server:spawn', CurrentJob.jobId, CurrentJob.jobDiff, CurrentJob.jobLocationName)
                    TriggerServerEvent('cw-raidjob2:server:UpdateStage', CurrentJob.jobId)
                break
            end
            Wait(1000)				-- mandatory wait
        end
    end)
end

local function setGps()
    local circleCenter = Config.Locations[CurrentJob.jobDiff][CurrentJob.jobLocationName].coords
    blipCircle = AddBlipForRadius(circleCenter.x, circleCenter.y, circleCenter.z , 60.0) -- you can use a higher number for a bigger zone
    SetBlipHighDetail(blipCircle, true)
    SetBlipColour(blipCircle, 1)
    SetBlipAlpha (blipCircle, 128)
    SetNewWaypoint(circleCenter.x, circleCenter.y)
end

RegisterNetEvent('cw-raidjob2:client:runactivate', function(jobId, jobDiff, jobLocation)
    onRun = true
    CurrentJob.jobDiff = jobDiff
    CurrentJob.jobLocationName = jobLocation
    CurrentJob.jobId = jobId
    CurrentJob.caseIsUnlocked = false
    CurrentJob.CaseIsInUse = false
    if useDebug then
        print('id', CurrentJob.jobId)
        print('diff', CurrentJob.jobDiff)
        print('location', CurrentJob.jobLocationName)
    end
    if not Config.UseRenewedPhoneGroups then
        RunStart()
    end
    setGps()
    checkDistance()
end)

local function getTableLength(table)
    local count = 0
    for i, v in pairs(table) do
        count = count+1
    end
    return count
end

local function generateNameList(diff, cooldowns)
    local names = {}
    if useDebug then print('generating name list') end
    for i, v in pairs(Config.Locations[diff]) do
        if useDebug then print('-- location', i) end
        if not cooldowns[i] then
            if useDebug then print('adding location') end
            names[#names+1] = i
        else
            if useDebug then print('this location was in cooldown') end
        end
    end
    return names
end

RegisterNetEvent('cw-raidjob2:client:attemptStart', function (data)
    if useDebug then
        print('Starting raid with diff', data.diff)
        print('Amount of locations for this level:',  getTableLength(Config.Locations[data.diff]))
    end

    QBCore.Functions.TriggerCallback("cw-raidjob2:server:getCooldowns",function(cooldowns)
        CurrentJob = Config.Jobs[data.diff]
        local nameList = generateNameList(data.diff, cooldowns)
        if #nameList == 0 then
            QBCore.Functions.Notify(Lang:t('error.someone_recently_did_this'), 'error')
            return
        end
        local rand = nameList[math.random(#nameList)]
        CurrentJob.jobLocationName = rand
        if useDebug then
           print('Randomly selected location:', CurrentJob.jobLocationName)
        end
    
        TriggerEvent('animations:client:EmoteCommandStart', {"idle11"})
        QBCore.Functions.Progressbar("start_job", Lang:t('info.talking_to_boss'), Config.BossTalkTime , false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
        }, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent('cw-raidjob2:server:start', data.diff, CurrentJob.jobLocationName)
        end, function() -- Cancel
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
        end)
    end)
end)

RegisterNetEvent('cw-raidjob2:client:caseUnlocked', function()
    CurrentJob = {}
    if Config.UseMZSkills then
        exports["mz-skills"]:UpdateSkill(Config.Skill, Config.SkillAmount)
    end
    SetTimeout(Config.CleanupTimer, function()
        CleanUp()
    end)
    onRun = false
end)

RegisterNetEvent('cw-raidjob2:client:jobCanceled', function(data)
    CurrentJob = {}
    if Config.UseMZSkills then
        exports["mz-skills"]:UpdateSkill(Config.Skill, -Config.SkillAmount)
    end
    SetTimeout(Config.CleanupTimer, function()
        CleanUp()
    end)
    onRun = false
    QBCore.Functions.Notify(Lang:t('info.job_canceled'), 'error')
end)

RegisterNetEvent('cw-raidjob2:client:caseGrabbed', function()
    RemoveBlip(blipCircle)
    blipCircle = nil
    CurrentJob.case = nil
end)

local function caseGrabbed()
    CurrentJob.case = nil
    if not Config.UseRenewedPhoneGroups then
        caseAquiredMessage()
    end

    local diff = CurrentJob.jobDiff
    SetTimeout(math.random(Config.Jobs[CurrentJob.jobDiff].lowTime, Config.Jobs[CurrentJob.jobDiff].highTime) , function()
        CurrentJob.caseIsUnlocked = true
        if not Config.UseRenewedPhoneGroups then
            caseIsUnlockedMessage(diff)
        end
        TriggerServerEvent('cw-raidjob2:server:tracker', CurrentJob.jobId)
    end)
end


local function MinigameSuccess()
    QBCore.Functions.Progressbar("grab_case", Lang:t('info.unlocking_case'), 500, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('cw-raidjob2:server:grabCase', CurrentJob.jobId, CurrentCops)

        if (IsPedActiveInScenario(PlayerPedId()) == false) then
            DeleteEntity(CurrentJob.case)
            QBCore.Functions.Notify(Lang:t("success.you_removed_first_security_case"), 'success')
            caseGrabbed()
        end
    end, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
    end)
end

local function MinigameFailiure()
    CurrentJob.CaseIsInUse = false
    TriggerServerEvent('cw-raidjob2:server:setCaseIsInUse', CurrentJob.jobId, false)
    QBCore.Functions.Notify(Lang:t("error.you_failed"), 'error')
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end

local function StartMinigame()
    CurrentJob.CaseIsInUse = true
    TriggerServerEvent('cw-raidjob2:server:setCaseIsInUse', CurrentJob.jobId, true)
    TriggerEvent('animations:client:EmoteCommandStart', {"parkingmeter"})
    if Config.Jobs[CurrentJob.jobDiff].Minigame.game then
        local type = Config.Jobs[CurrentJob.jobDiff].Minigame.game
        local variables = Config.Jobs[CurrentJob.jobDiff].Minigame.variables
        if type == "Circle" then
            exports['ps-ui']:Circle(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2]) -- NumberOfCircles, MS
        elseif type == "Maze" then
            exports['ps-ui']:Maze(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1]) -- Hack Time Limit
        elseif type == "VarHack" then
            exports['ps-ui']:VarHack(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
             end, variables[1], variables[2]) -- Number of Blocks, Time (seconds)
        elseif type == "Thermite" then
            exports["ps-ui"]:Thermite(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2], variables[3]) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
        elseif type == "Scrambler" then
            exports['ps-ui']:Scrambler(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2], variables[3]) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
        end
    else
        exports["ps-ui"]:Thermite(function(success)
            if success then
                MinigameSuccess()
            else
                MinigameFailiure()
            end
        end, 8, 5, 3) -- Success
    end
end

RegisterNetEvent('cw-raidjob2:client:attemtpToUnlockCase', function(diff, jobid, copsOnline)
    if useDebug then
        print(diff,jobid, currentCop)
    end
    TriggerServerEvent('cw-raidjob2:server:unlock', diff, jobid, copsOnline)
end)

RegisterNetEvent('cw-raidjob2:client:items', function()
    TriggerEvent("qb-dispatch:raidJob")
    StartMinigame()
end)

RegisterNetEvent('cw-raidjob2:client:theftCall', function()
    if not isLoggedIn then return end
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "police" and PlayerJob.onduty then
        local bank
        bank = "Fleeca"
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local vehicleCoords = GetEntityCoords(MissionVehicle)
        local s1, s2 = GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local streetLabel = street1
        if street2 then streetLabel = streetLabel .. " " .. street2 end
        local plate = GetVehicleNumberPlateText(MissionVehicle)
        TriggerServerEvent('police:server:policeAlert', Lang:t("police.alert")..plate)
    end
end)

RegisterNetEvent('cw-raidjob2:client:setCaseIsInUse', function(bool)
    CurrentJob.CaseIsInUse = bool
end)

AddEventHandler('onResourceStop', function (resource)

    if resource ~= GetCurrentResourceName() then return end
    print('restarting Raidjob2')
    CleanUp()
end)
