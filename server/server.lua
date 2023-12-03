local QBCore = exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug

-- Constants
local PlayerPopGroup = 'RaidPlayerGroup'
local GuardPopGroup = 'RaidGuardGroup'
local CivPopGroup = 'RaidCivGroup'

-- Globals
local Cooldown = false
local ActiveJobs = {}
--[[
    ActiveJobs = {
        JobId = {
            diff = jobDiff,
            location = jobLocation,
            leader = src
            Group = {
                src = 1
            }
            spawnTriggered = false
        }
    }
--]]
local Npcs = {
    ['RaidGuardGroup'] = {},
    ['RaidCivGroup'] = {}
}

-- == Start == --
local function verifyIsLeader(src)
    if Config.UseRenewedPhoneGroups and exports['qb-phone']:GetGroupByMembers(src) then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local leader = exports['qb-phone']:GetGroupLeader(group)
        return leader == src
    else
        return true
    end
end

local function verifyGroupSize(src)
    if Config.UseRenewedPhoneGroups and exports['qb-phone']:GetGroupByMembers(src) then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local size = exports['qb-phone']:getGroupSize(group)
        return size <= Config.MaxGroupSize
    else
        return true
    end
end

local function generateJobId()
    local jobId = "RJ-" .. math.random(1111, 9999)
    while ActiveJobs[jobId] ~= nil do
        jobId = "RJ-" .. math.random(1111, 9999)
    end
    return jobId
end

local function Notifications(src, type, msg, group)
    if group then
        exports['qb-phone']:pNotifyGroup(group,
            " Transport",
            msg,
            "fas fa-briefcase",
            "#2193eb",
            7500
        )
    else
        TriggerClientEvent('QBCore:Notify', src, msg, type)
    end
end

local function activateRun(src, jobDiff, jobLocation)
    print(src, jobDiff, jobLocation)
    local jobId = generateJobId()

    ActiveJobs[jobId] = {
        status = "",
        diff = jobDiff,
        location = jobLocation,
        leader = src,
        spawnTriggered = false,
        Group = {},
        Stages = {}
    }
    if Config.UseRenewedPhoneGroups then
        local Player = QBCore.Functions.GetPlayer(src)

        local group = exports['qb-phone']:GetGroupByMembers(src) or exports['qb-phone']:CreateGroup(src, "Group-" .. Player.PlayerData.citizenid)
        if not group then return end

        local Size = exports['qb-phone']:getGroupSize(group)

        if Size > Config.MaxGroupSize then
            TriggerClientEvent('QBCore:Notify', src,
                "Your group can only have a maximum of " .. Config.MaxGroupSize .. " participants for this...", "error")
        return false end

        if exports['qb-phone']:getJobStatus(group) ~= "WAITING" then
            TriggerClientEvent('QBCore:Notify', src, "Your group is currently busy with a different job...", "error")
        return false end

        if not exports['qb-phone']:isGroupLeader(src, group) then
            TriggerClientEvent('QBCore:Notify', src, "I cannot give you a job if you're not the group leader...", "error")
        return false end


        local members = exports['qb-phone']:getGroupMembers(group)
        ActiveJobs[jobId] = {
            status = "On Run",
            diff = jobDiff,
            location = jobLocation,
            leader = src,
            spawnTriggered = false,
            Stages = {
                { name = "Find your pickup point", isDone = false, id = 1 },
                { name = "Grab the case",          isDone = false, id = 2 },
            }
        }
        Notifications(_, _, "Go to your pickup spot", group)
        exports['qb-phone']:setJobStatus(group, ("Transport Job"):format(), ActiveJobs[jobId].Stages)
        for i, v in pairs(members) do
            TriggerClientEvent('cw-raidjob2:client:runactivate', v, jobId, jobDiff, jobLocation)
        end
        return true
    else
        ActiveJobs[jobId].Group = {
            [src] = 1
        }
        TriggerClientEvent('cw-raidjob2:client:runactivate', src, jobId, jobDiff, jobLocation)
        return true
    end
end

local function addItem(item, amount, info, src)
    exports.ox_inventory:AddItem(src, item, amount, info)
    TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[item], "add")
end

local function removeItem(item, slot, src)
    local Player = QBCore.Functions.GetPlayer(src)
    exports.ox_inventory:RemoveItem(src, item, 1, nil, slot)
    TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[item], "remove")

end

local function removeItemBySlot(item, jobId, src)
        local result = exports.ox_inventory:Search(src, 'slots', item, { jobID = jobId })
        if useDebug then
            print('fetched slot:', result[1].slot)
        end
        if #result > 0 then
            removeItem(item, result[1].slot, src)
            return true
        else
            return false
        end
end

local function hasItem(item, jobId, src)
    local result = exports.ox_inventory:Search(src, 'slots', item, { jobID = jobId })
    if #result > 0 then
        return true
    else
        return false
    end
end

RegisterServerEvent('cw-raidjob2:server:start', function(jobDiff, jobLocation)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if useDebug then
        print(jobDiff, jobLocation)
    end
    if verifyIsLeader and verifyGroupSize then
        if Config.UseTokens then
            TriggerEvent('cw-tokens:server:TakeToken', src, Config.Jobs[jobDiff].token)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
            activateRun(src, jobDiff, jobLocation)
        else
            local paymentType = Config.Jobs[jobDiff].paymentType
            local runCost = Config.Jobs[jobDiff].runCost
            if useDebug then
                print('payout', paymentType, runCost)
            end
            if paymentType == 'cash' then
                if Player.PlayerData.money['cash'] >= runCost then
                    if activateRun(src, jobDiff, jobLocation) then
                        Player.Functions.RemoveMoney('cash', runCost)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
                        TriggerEvent('cw-raidjob2:server:coolout', src)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                end
            elseif paymentType == 'bank' then
                if Player.PlayerData.money['bank'] >= runCost then
                    if activateRun(src, jobDiff, jobLocation) then
                    Player.Functions.RemoveMoney('bank', runCost)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
                    TriggerEvent('cw-raidjob2:server:coolout', src)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                end
            elseif paymentType == 'crypto' then
                if Config.UseRenewedCrypto then
                    if exports['qb-phone']:hasEnough(src, Config.CryptoType, runCost) then
                        if activateRun(src, jobDiff, jobLocation) then
                            exports['qb-phone']:RemoveCrypto(src, Config.CryptoType, runCost)
                            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
                            TriggerEvent('cw-raidjob2:server:coolout', src)
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                    end
                else
                    if Player.PlayerData.money['crypto'] >= runCost then
                        if activateRun(src, jobDiff, jobLocation) then
                            Player.Functions.RemoveMoney('crypto', tonumber(runCost))
                            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
                            TriggerEvent('cw-raidjob2:server:coolout', src)
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                    end
                end
            end

        end
    end
end)

local function shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local npcVehicles = {}
-- Spawning
local function spawnVehicles(jobId, jobDiff, jobLocation)
    -- Bad Guys cars
    local CurrentJobLocation = Config.Locations[jobDiff][jobLocation]
    local vehicles = CurrentJobLocation.GuardCars
    if vehicles then
        local vehicleList = {}
        for i, vehicle in pairs(vehicles) do
            local GuardVehicleCoords = vehicle.coords
            local transport = CreateVehicle(vehicle.model, GuardVehicleCoords.x, GuardVehicleCoords.y, GuardVehicleCoords.z, GuardVehicleCoords.w, true, true)
            Wait(1000)
            while not DoesEntityExist(transport) do
                if useDebug then
                    print('vehicle dont exist', transport)
                end
                Wait(500)
            end
            local networkID = 'SOMETHINGSWRONG'
            if DoesEntityExist(transport) then
                networkID = NetworkGetNetworkIdFromEntity(transport)
            end

            if useDebug then
                print('vehicle', transport, networkID)
            end
            vehicleList[networkID] = transport
        end
        npcVehicles[jobId] = vehicleList
    end
end

local GuardStats = {}

local function spawnGuards(jobId, jobDiff, jobLocation)
    local CurrentJobLocation = Config.Locations[jobDiff][jobLocation]
    local listOfGuardPositions = nil

    if CurrentJobLocation.GuardPositions ~= nil then
        listOfGuardPositions = shallowCopy(CurrentJobLocation.GuardPositions) -- these are used if random positions
    end

    for k, v in pairs(CurrentJobLocation.Guards) do
        local guardPosition = v.coords
        local animation = nil
        if guardPosition == nil then
            if listOfGuardPositions == nil then
                print('Someone made an oopsie when making guard positions!')
            else
                local random = math.random(1, #listOfGuardPositions)
                guardPosition = listOfGuardPositions[random]
                table.remove(listOfGuardPositions, random)
            end
        end
        local accuracy = Config.DefaultValues.accuracy
        if v.accuracy then
            accuracy = v.accuracy
        end
        local armor = Config.DefaultValues.armor
        if v.armor then
            armor = v.armor
        end

        -- print('Guard location: ', guardPosition)

        local ped = CreatePed(26, GetHashKey(v.model), guardPosition, true, true)


        while not DoesEntityExist(ped) do
           Wait(100)
        end

        local networkID =  NetworkGetNetworkIdFromEntity(ped)

        local weapon = 'WEAPON_PISTOL'
        if v.weapon then
            weapon = v.weapon
        end

        GiveWeaponToPed(ped, weapon, 255, false, false)
        SetPedRandomComponentVariation(ped, 0)
        SetPedRandomProps(ped)
        SetPedArmour(ped, armor)

        Npcs[GuardPopGroup][networkID] = ped
        GuardStats[networkID] = {
            accuracy = accuracy,
            hasKey = false
        }
        if k == 1 then
            if Config.Debug then
                print('giving key to', networkID)
            end
            ActiveJobs[jobId].KeyHolder = networkID
            GuardStats[networkID].hasKey = true
        end
    end
    Wait(5000)
    if Config.UseRenewedPhoneGroups then
        local group = exports['qb-phone']:GetGroupByMembers(ActiveJobs[jobId].leader)
        local members = exports['qb-phone']:getGroupMembers(group)
        for i, v in pairs(members) do
            if Config.Debug then
                print('updating npcs for', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:setRelationsAndStats', v, Npcs, GuardStats)
        end
    else
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if Config.Debug then
                print('updating npcs for', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:setRelationsAndStats', i, Npcs, GuardStats)
        end
    end
end

local function spawnCase(jobId, jobDiff, jobLocation)
    local CasePositions = Config.Locations[jobDiff][jobLocation].CasePositions

    local prop = Config.Items.caseProp

    local caseLocation = CasePositions[math.random(1, #CasePositions)]

    local case = CreateObject(prop, caseLocation.x, caseLocation.y, caseLocation.z, true, true, true)
    ActiveJobs[jobId].caseEntity = case
    if useDebug then
        print(caseLocation.x, caseLocation.y, caseLocation.z)
        print('case:', case)
    end
    while not DoesEntityExist(case) do
        print('case dont exist')
        Wait(1000)
    end

    local networkID = 'SOMETHINGSWRONG'
    if DoesEntityExist(case) then
        networkID = NetworkGetNetworkIdFromEntity(case)
        print("Case Exists", NetworkGetNetworkIdFromEntity(case))
    end
    SetEntityHeading(case, math.random(180) * 1.0)
    FreezeEntityPosition(case, true)

    if Config.UseRenewedPhoneGroups then
        local group = exports['qb-phone']:GetGroupByMembers(ActiveJobs[jobId].leader)
        local members = exports['qb-phone']:getGroupMembers(group)
        for i, v in pairs(members) do
            if useDebug then
                print('pinging player about case', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:spawnCase', v, networkID)
        end
    else
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
                print('pinging player about case', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:spawnCase', i, networkID)
        end
    end
end

RegisterNetEvent('cw-raidjob2:server:spawn', function(jobId, jobDiff, jobLocation)
    if useDebug then
        print('spawning for', jobId, jobDiff, jobLocation)
    end
    if ActiveJobs[jobId].spawnTriggered == false then
        ActiveJobs[jobId].spawnTriggered = true
        spawnGuards(jobId, jobDiff, jobLocation)
        spawnVehicles(jobId, jobDiff, jobLocation)
        spawnCase(jobId, jobDiff, jobLocation)

        if Config.UseRenewedPhoneGroups then
            local group = exports['qb-phone']:GetGroupByMembers(ActiveJobs[jobId].leader)
            local members = exports['qb-phone']:getGroupMembers(group)
            for i, v in pairs(members) do
                if useDebug then
                    print('updating vehicles for', i, v)
                end
                TriggerClientEvent('cw-raidjob2:client:setVehicleEntities', v, npcVehicles[jobId])
            end
        else
            for i, v in pairs(ActiveJobs[jobId].Group) do
                if useDebug then
                    print('notifying that enemies are spawning', i, v)
                end
                TriggerClientEvent('cw-raidjob2:client:updateSpawned', i)
                if useDebug then
                    print('updating vehicles for', i, v)
                end
                TriggerClientEvent('cw-raidjob2:client:setVehicleEntities', i, npcVehicles[jobId])
            end
        end
    end
end)

RegisterNetEvent('cw-raidjob2:server:UpdateStage', function(jobid)
    local group = exports['qb-phone']:GetGroupByMembers(source)

    ActiveJobs[jobid].Stages = {
        { name = "Find your pickup point", isDone = true,  id = 1 },
        { name = "Take out the hostiles",  isDone = false, id = 2 },
        { name = "Grab the case",          isDone = false, id = 3 }
    }

    exports['qb-phone']:setJobStatus(group, ("Transport Job"):format(), ActiveJobs[jobid].Stages)
end)

RegisterNetEvent('cw-raidjob2:server:hasKeys', function(jobId)
    local src = source
    if useDebug then
        print(src, 'found the keys')
    end
    local item = Config.Items.key
    addItem(item, 1, { diff = ActiveJobs[jobId].diff, jobID = jobId}, src)
    if Config.UseRenewedPhoneGroups then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local members = exports['qb-phone']:getGroupMembers(group)
        if not ActiveJobs[jobId].hasCase then
            ActiveJobs[jobId].Stages = {
                { name = "Find your pickup point", isDone = true,  id = 1 },
                { name = "Take out the hostiles",  isDone = true,  id = 2 },
                { name = "Grab the case",          isDone = true,  id = 3 },
                { name = "Unlock the case!",       isDone = false, id = 4 },
            }
        else
            ActiveJobs[jobId].Stages = {
                { name = "Find your pickup point", isDone = true,  id = 1 },
                { name = "Take out the hostiles",  isDone = true,  id = 2 },
                { name = "Grab the case",          isDone = true,  id = 3 },

            }
        end
        exports['qb-phone']:setJobStatus(group, ("Transport Job"):format(), ActiveJobs[jobId].Stages)
        for i, v in pairs(members) do
            if useDebug then
                print('notifying player about key', v)
            end
            TriggerClientEvent('cw-raidjob2:client:setKeyTaken', v, ActiveJobs[jobId].KeyHolder)
        end
    else
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
                print('notifying player about key', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:setKeyTaken', i)
        end
    end
    ActiveJobs[jobId].hasKey = true
end)

RegisterNetEvent('cw-raidjob2:server:setCaseIsInUse', function(jobId, bool)
    local src = source

    if useDebug then
        print(src, 'interacting with case')
    end

    if not Config.UseRenewedPhoneGroups then
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
                print('notifying player about case interaction', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:setCaseIsInUse', i, bool)
        end
    else
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local members = exports['qb-phone']:getGroupMembers(group)
        for i, v in pairs(members) do
            if useDebug then
                print('notifying player about case interaction', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:setCaseIsInUse', v, bool)
        end
    end
end)

RegisterServerEvent('cw-raidjob2:server:grabCase', function(jobId, copAmount)
    local src = source
    if useDebug then
        print(src, 'Grabbed case', jobId)
    end

    local caseItem = Config.Items.caseItem
    ActiveJobs[jobId].hasCase = true
    addItem(caseItem, 1, { diff = ActiveJobs[jobId].diff, jobID = jobId, copsOnline = copAmount }, src)
    if Config.UseRenewedPhoneGroups then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local members = exports['qb-phone']:getGroupMembers(group)
        if not ActiveJobs[jobId].hasKey then
            ActiveJobs[jobId].Stages = {
                { name = "Find your pickup point", isDone = true,  id = 1 },
                { name = "Take out the hostiles",  isDone = true,  id = 2 },
                { name = "Grab the case",          isDone = true,  id = 3 },
                { name = "Find the fucking key!",  isDone = false, id = 4 }
            }
        else
            ActiveJobs[jobId].Stages = {
                { name = "Find your pickup point", isDone = true,  id = 1 },
                { name = "Take out the hostiles",  isDone = true,  id = 2 },
                { name = "Grab the case",          isDone = true,  id = 3 },
                { name = "Unlock the case!",       isDone = false, id = 4 }
            }
        end
        Notifications(_, _, "There's a tracker on the case! Get out of there!", group)
        exports['qb-phone']:setJobStatus(group, ("Transport Job"):format(), ActiveJobs[jobId].Stages)
        DeleteEntity(ActiveJobs[jobId].caseEntity)
        for i, v in pairs(members) do
            if useDebug then
                print('notifying player about case grabbed', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:caseGrabbed', v)
        end
    else
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
                print('notifying player about case grabbed', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:caseGrabbed', i)
        end
    end
end)

RegisterServerEvent('cw-raidjob2:server:unlock', function(diff, jobid, currentCops)
    local src = source
    local caseContent = Config.Items.caseContent
    local caseItem = Config.Items.caseItem
    local caseKey = Config.Items.key

    if hasItem(caseKey, jobid, src) then
        if hasItem(caseItem, jobid, src) then
            if removeItemBySlot(caseItem, jobid, src) then
                if removeItemBySlot(caseKey, jobid, src) then
                    if useDebug then
                        print(src, 'Unlocked case', jobId)
                    end
                    addItem(caseContent, 1, { diff = diff, copsOnline = currentCops, jobID = jobId }, src)
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_case"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_key"), 'error')
    end
end)


RegisterNetEvent('cw-raidjob2:server:tracker', function(jobId)
    local src = source
    if Config.UseRenewedPhoneGroups then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local members = exports['qb-phone']:getGroupMembers(group)
        for i, v in pairs(members) do
            if useDebug then
                print('notifying player about case unlocked', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:caseUnlocked', v)
        end
        Notifications(_, _, "Tracker is Disabled, Open the case and bring me the documents!", group)
        if exports['qb-phone']:isGroupTemp(group) then
            exports['qb-phone']:DestroyGroup(group)
        else
            exports['qb-phone']:resetJobStatus(group)
        end
    else
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
                print('notifying player about case unlocked', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:caseUnlocked', i)
        end
    end
end)

RegisterServerEvent('cw-raidjob2:server:givePayout', function(diff)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local caseContent = Config.Items.caseContent

    if removeItemBySlot(caseContent, diff, src) then
        for k, v in pairs(Config.Jobs[diff].Rewards) do
            local chance = math.random(0, 100)
            if useDebug then
                print('chance for ' .. v.item .. ': ' .. chance)
            end
            if chance < v.chance then
                Player.Functions.AddItem(v.item, v.amount)
            end
        end

        local payoutType = Config.Jobs[diff].payoutType
        local payoutAmount = Config.Jobs[diff].payout

        local items = exports.ox_inventory:Search(source, "slots", caseContent)
        for _, item in pairs(items) do
            if item.metadata.diff == diff then
                if item.metadata.copsOnline == 0 then
                    print("COP PAYOUT :", item.metadata.copsOnline * Config.Jobs[item.metadata.diff].copBonus)
                    payoutAmount = math.floor(payoutAmount + (item.metadata.copsOnline * Config.Jobs[item.metadata.diff].copBonus))
                end
            end
        end

        if useDebug then
            print('payout', payoutType, payoutAmount)
        end
        if payoutType == 'cash' then
            Player.Functions.AddMoney('cash', payoutAmount, 'Raid job payment: ' .. diff)
        elseif payoutType == 'bank' then
            Player.Functions.AddMoney('bank', payoutAmount, 'Raid job payment: ' .. diff)
        elseif payoutType == 'crypto' then
            if Config.UseRenewedCrypto then
                exports['qb-phone']:AddCrypto(src, Config.CryptoType, payoutAmount)
            else
                Player.Functions.AddMoney('crypto', tonumber(payoutAmount), 'Raid job payment: ' .. diff)
            end
        end
    else
        QBCore.Functions.Notify(source, 'Dont Have Item?', 'error', 7500)
    end
end)

QBCore.Functions.CreateUseableItem(Config.Items.caseItem, function(source, item)
    if useDebug then print("USING ITEM : ", item.metadata.diff, item.metadata.jobID, item.metadata.copsOnline) end
    TriggerClientEvent('cw-raidjob2:client:attemtpToUnlockCase', source, item.metadata.diff, item.metadata.jobID,  item.metadata.copsOnline)
end)

-- cool down for job
RegisterServerEvent('cw-raidjob2:server:coolout', function()
    if useDebug then
        print('STARTING COOLDOWN')
    end
    Cooldown = true
    local timer = Config.Cooldown * 1000
    SetTimeout(timer, function()
        Cooldown = false
    end)
end)

QBCore.Functions.CreateCallback("cw-raidjob2:server:isInCooldown", function(source, cb)
    cb(Cooldown)
end)

RegisterServerEvent('cw-raidjob2:server:cancelJob', function(jobId)
    if Config.UseRenewedPhoneGroups then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local members = exports['qb-phone']:getGroupMembers(group)
        if exports['qb-phone']:isGroupTemp(group) then
            exports['qb-phone']:DestroyGroup(group)
        else
            exports['qb-phone']:resetJobStatus(group)
        end
        for i, v in pairs(members) do
            if useDebug then
                print('canceling job', jobId, i)
            end
            TriggerClientEvent('cw-raidjob2:client:jobCanceled', v)
        end
    else
        for i, v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
                print('canceling job', jobId, i)
            end
        TriggerClientEvent('cw-raidjob2:client:jobCanceled', i)
    end
    end

end)
