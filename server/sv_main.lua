local originalPlate     = originalPlate
local originalNetId     = originalNetId
local fakePlate         = fakePlate
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
end

if Config.Standalone then
    RegisterCommand('fakePlate', function(source, args) 
        -- Sets the fake Plate
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
                            TriggerEvent('WP:getPlate', source, ped)
                        elseif fakePlateActive and Config.allowMultipleFakes then
                            TriggerEvent('WP:getPlate', source, ped)
                        elseif fakePlateActive and not Config.allowMultipleFakes then
                            TriggerClientEvent('NFPWD:notifyError', source, 'You have a fake plate already in use!')
                        end
                    else
                        TriggerClientEvent('NFPWD:notifyError', source, 'Ownership Required!')
                    end
                end)
            end
        else
            if not fakePlateActive then
                TriggerEvent('WP:getPlate', source, ped)
            elseif fakePlateActive and Config.allowMultipleFakes then
                TriggerEvent('WP:getPlate', source, ped)
            elseif fakePlateActive and not Config.allowMultipleFakes then
                TriggerClientEvent('NFPWD:notifyError', source, 'You have a fake plate already in use!')
            end
        end
    end, Config.restrictCommands)

    RegisterCommand('returnPlate', function(source, args) 
        -- Sets the original Plate
        local source            = source
        if source > 0 then
            local ped           = GetPlayerPed(source)
            local netVehicle    = GetVehiclePedIsIn(ped, true)
            local netId         = NetworkGetNetworkIdFromEntity(netVehicle)
            local activePlate   = GetVehicleNumberPlateText(netVehicle)
            if activePlate ~= originalPlate then
                if netId == originalNetId then
                    local currentDistance = #(GetEntityCoords(ped) - GetEntityCoords(netVehicle))
                    if currentDistance <= maxDistance then
                        TriggerClientEvent('WP:setPlate', source, netId, originalPlate, fakePlate, 'return')
                    else
                        TriggerClientEvent('NFPWD:notifyError', source, 'Vehicle is too far away!')
                    end
                else
                    if fakePlateActive then
                        TriggerClientEvent('NFPWD:notifyError', source, "This plate doesn't belong to this vehicle!")
                    else
                        TriggerClientEvent('NFPWD:notifyError', source, "No plate to change!")
                    end
                end
            else
                TriggerClientEvent('NFPWD:notifyError', source, "Vehicle already has this plate!")
            end
        end
    end, Config.restrictCommands)
end
RegisterNetEvent('WP:getPlate', function(source, ped)
    local netVehicle    = GetVehiclePedIsIn(ped, true)
    originalNetId       = NetworkGetNetworkIdFromEntity(netVehicle)
    if not fakePlateActive then
        originalPlate   = GetVehicleNumberPlateText(netVehicle)
    end
    fakePlate           = Utils.generatePlate(2)

    local currentDistance = #(GetEntityCoords(ped) - GetEntityCoords(netVehicle))
    if currentDistance <= maxDistance then
        TriggerClientEvent('WP:setPlate', source, originalNetId, originalPlate, fakePlate, 'fake')
    else
        TriggerClientEvent('NFPWD:notifyError', source, 'Vehicle is too far away!')
    end
end)

RegisterNetEvent('plateSuccess', function(cl_OriginalPlate, cl_FakePlate, plateType)
    local source   = source
    if Config.useESX then
        local ply      = ESX.GetPlayerFromId(source)
    end
    if cl_OriginalPlate == originalPlate and cl_FakePlate == fakePlate then
        if plateType == 'fake' then
            fakePlateActive = true
            TriggerClientEvent('NFPWD:notifySuccess', source, 'Fake plate applied!')
            Utils.Debug('success', "^1[Fake]^2 Plate Applied.^7")
            Utils.Debug('success', "Vehicle plate set to: ^1["..cl_FakePlate.."]^7")
            if Config.useESX then
                ply.addInventoryItem("plate", 1)
                ply.removeInventoryItem("fakeplate", 1)
            end
        elseif plateType == 'return' then
            fakePlateActive = false
            originalPlate   = nil
            originalNetId   = nil
            fakePlate       = nil
            TriggerClientEvent('NFPWD:notifySuccess', source, 'Original plate applied!')
            Utils.Debug('success', "^5[Original]^2 Plate Applied.^7")
            Utils.Debug('success', "Vehicle plate set to: ^5["..cl_OriginalPlate.."]^7")
            if Config.useESX then
                ply.addInventoryItem("fakeplate", 1)
                ply.removeInventoryItem("plate", 1)
            end
        end
    else
        Utils.Debug('error', "The server plates is different from the client plates.")
        if Config.dropPlayer then
            DropPlayer(source, "Server check failed. Invalid vehicle plate. Please contact server staff.")
            -- Add webhook since possible cheater.
        end
    end
end)

if Config.useESX then
    -- Register usuable items and do item checks.
end
