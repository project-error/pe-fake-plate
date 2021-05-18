local originalPlate     = originalPlate
local originalNetId     = originalNetId
local fakePlate         = fakePlate
local applyingPlate     = applyingPlate
local fakePlateActive   = nil
local maxDistance       = 4
ESX                     = nil

if Config.useMysqlAsync then
    fetchScalar         = MySQL.Async.fetchScalar
end

if Config.useGhmattimysql then
    fetchScalar         = exports.ghmattimysql.scalar 
end

if Config.useESX then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    ESX.RegisterUsableItem('plate', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerEvent('pe-fake-plate:startReturnPlate', source)
    end)
    ESX.RegisterUsableItem('fakeplate', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerEvent('pe-fake-plate:startFakePlate', source)
    end)
end

if Config.Standalone then
    RegisterCommand('fakePlate', function(source, args) 
        TriggerEvent('pe-fake-plate:startFakePlate', source)
    end, Config.restrictCommands)

    RegisterCommand('returnPlate', function(source, args) 
       TriggerEvent('pe-fake-plate:startReturnPlate', source)
    end, Config.restrictCommands)
end

RegisterNetEvent('pe-fake-plate:startFakePlate', function(source)
    local source        = source
    local identifier    = Utils.getPlayerIdentifier(source)
    local ped           = GetPlayerPed(source)
    local netVehicle    = GetVehiclePedIsIn(ped, true)
    local plate         = GetVehicleNumberPlateText(netVehicle)
    if Config.ownerRestricted then
        if identifier then
            fetchScalar('SELECT 1 FROM '..Config.databaseName..' WHERE (owner, plate) = (@owner, @plate)', {
                ['owner']          = identifier,
                ['plate']          = plate,
            }, function(results)
                if results then
                    Utils.Debug('inform', "Vehicle Owner")
                    if not fakePlateActive then
                        TriggerEvent('pe-fake-plate:getPlate', source, ped)
                    elseif fakePlateActive and Config.allowMultipleFakes then
                        TriggerEvent('pe-fake-plate:getPlate', source, ped)
                    elseif fakePlateActive and not Config.allowMultipleFakes then
                        if DoesEntityExist(netVehicle) then
                            TriggerClientEvent('pe-fake-plate:notifyError', source, 'You have a fake plate already in use!')
                        else
                            TriggerEvent('pe-fake-plate:getPlate', source, ped)
                        end
                    end
                else
                    TriggerClientEvent('pe-fake-plate:notifyError', source, 'Ownership Required!')
                end
            end)
        end
    else
        if not fakePlateActive then
            TriggerEvent('pe-fake-plate:getPlate', source, ped)
        elseif fakePlateActive and Config.allowMultipleFakes then
            TriggerEvent('pe-fake-plate:getPlate', source, ped)
        elseif fakePlateActive and not Config.allowMultipleFakes then
            if DoesEntityExist(netVehicle) then
                TriggerClientEvent('pe-fake-plate:notifyError', source, 'You have a fake plate already in use!')
            else
                TriggerEvent('pe-fake-plate:getPlate', source, ped)
                Utils.Debug('inform', "Entity doesn't exist, allowing fake plate.") 
            end
        end
    end
end)

RegisterNetEvent('pe-fake-plate:startReturnPlate', function(source)
    local source        = source
    local ped           = GetPlayerPed(source)
    local netVehicle    = GetVehiclePedIsIn(ped, true)
    local netId         = NetworkGetNetworkIdFromEntity(netVehicle)
    local activePlate   = GetVehicleNumberPlateText(netVehicle)
    if activePlate ~= originalPlate then
        if netId == originalNetId then
            local currentDistance = #(GetEntityCoords(ped) - GetEntityCoords(netVehicle))
            if currentDistance <= maxDistance then
                TriggerClientEvent('pe-fake-plate:setPlate', source, netId, originalPlate, fakePlate, 'return')
            else
                if DoesEntityExist(netVehicle) then
                    TriggerClientEvent('pe-fake-plate:notifyError', source, 'Vehicle is too far away!')
                else
                    TriggerClientEvent('pe-fake-plate:notifyError', source, "No plate to change, vehicle doesn't exist!")
                    resetStatus()
                end
            end
        else
            if fakePlateActive then
                TriggerClientEvent('pe-fake-plate:notifyError', source, "This plate doesn't belong to this vehicle!")
            else
                TriggerClientEvent('pe-fake-plate:notifyError', source, "No plate to change, fake plate isn't active!")
            end
        end
    else
        if DoesEntityExist(netVehicle) then
            TriggerClientEvent('pe-fake-plate:notifyError', source, "Vehicle already has this plate!")
        else
            TriggerClientEvent('pe-fake-plate:notifyError', source, "No plate to change, vehicle doesn't exist!")
            resetStatus() 
        end
    end
end)

RegisterNetEvent('pe-fake-plate:getPlate', function(source, ped)
    if not applyingPlate then
        local netVehicle    = GetVehiclePedIsIn(ped, true)
        originalNetId       = NetworkGetNetworkIdFromEntity(netVehicle)
        if not fakePlateActive then
            originalPlate   = GetVehicleNumberPlateText(netVehicle)
        end
        fakePlate           = Utils.generatePlate(2)

        local currentDistance = #(GetEntityCoords(ped) - GetEntityCoords(netVehicle))
        if currentDistance <= maxDistance then
            TriggerClientEvent('pe-fake-plate:setPlate', source, originalNetId, originalPlate, fakePlate, 'fake')
            applyingPlate = true
        elseif netVehicle > 0 then
            TriggerClientEvent('pe-fake-plate:notifyError', source, 'Vehicle is too far away!')
        elseif netVehicle == 0 then
            if GetVehiclePedIsIn(ped, false) == 0 then
                TriggerClientEvent('pe-fake-plate:notifyError', source, 'You must enter a vehicle first!')
            end
        end
    else
        TriggerClientEvent('pe-fake-plate:notifyError', source, "You're already applying a plate!.")
    end
end)

RegisterNetEvent('plateSuccess', function(cl_OriginalPlate, cl_FakePlate, plateType)
    local source   = source
    if Config.useESX then
        local xPlayer      = ESX.GetPlayerFromId(source)
    end
    if originalPlate ~= nil and fakePlate ~= nil then
        if cl_OriginalPlate == originalPlate and cl_FakePlate == fakePlate then
            if plateType == 'fake' then
                fakePlateActive = true
                applyingPlate   = false
                TriggerClientEvent('pe-fake-plate:notifySuccess', source, 'Fake plate applied!')
                Utils.Debug('success', "^1[Fake]^2 Plate Applied.^7")
                Utils.Debug('success', "Vehicle plate set to: ^1["..cl_FakePlate.."]^7")
                if Config.useESX then
                    xPlayer.addInventoryItem("plate", 1)
                    xPlayer.removeInventoryItem("fakeplate", 1)
                end
            elseif plateType == 'return' then
                resetStatus()
                TriggerClientEvent('pe-fake-plate:notifySuccess', source, 'Original plate applied!')
                Utils.Debug('success', "^5[Original]^2 Plate Applied.^7")
                Utils.Debug('success', "Vehicle plate set to: ^5["..cl_OriginalPlate.."]^7")
                if Config.useESX then
                    xPlayer.removeInventoryItem("plate", 1)
                end
            end
        else
            Utils.Debug('error', " "..GetPlayerName(source).." set a "..plateType.." that was different from the server plate.")
            Utils.Debug('error', "Return Plate: "..cl_OriginalPlate.." Fake Plate: "..cl_FakePlate.."")
            if Config.dropPlayer then
                DropPlayer(source, "Server check failed. Invalid vehicle plate. Please contact server staff.")
                -- Add webhook since possible cheater.
            end
        end
    end
end)

RegisterNetEvent('pe-fake-plate:disableBool', function()
    applyingPlate = false
end)

function resetStatus()
    fakePlateActive = false
    applyingPlate   = false
    originalPlate   = nil
    originalNetId   = nil
    fakePlate       = nil
    Utils.Debug('inform', "Status was reset!") 
end