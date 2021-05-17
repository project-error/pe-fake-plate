local originalPlate     = originalPlate
local originalNetId     = originalNetId
local fakePlate         = fakePlate
local fakePlateActive   = nil
local maxDistance       = 4

if Config.useMysqlAsync then
    execute     = MySQL.Async.execute
    fetchAll    = MySQL.Async.fetchAll
    fetchScalar = MySQL.Async.fetchScalar
end

if Config.useGhmattimysql then
    execute   = exports.ghmattimysql.execute
    fetchAll  = exports.ghmattimysql.execute 
end

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
                        TriggerClientEvent('WC:notify', source, "error", 1000, nil, "You have a fake plate already in use.")
                    end
                else
                    TriggerClientEvent('WC:notify', source, "error", 1000, nil, "Ownership required")
                end
            end)
        end
    else
        if not fakePlateActive then
            TriggerEvent('WP:getPlate', source, ped)
        elseif fakePlateActive and Config.allowMultipleFakes then
            TriggerEvent('WP:getPlate', source, ped)
        elseif fakePlateActive and not Config.allowMultipleFakes then
            TriggerClientEvent('WC:notify', source, "error", 1000, nil, "You have a fake plate already in use.")
        end
    end
end, Config.restrictCommands)

RegisterCommand('returnPlate', function(source, args) 
    -- Sets the original Plate
    local playerId = source
    if playerId > 0 then
        local ped           = GetPlayerPed(playerId)
        local netVehicle    = GetVehiclePedIsIn(ped, true)
        local netId         = NetworkGetNetworkIdFromEntity(netVehicle)
        local activePlate   = GetVehicleNumberPlateText(netVehicle)
        if activePlate ~= originalPlate then
            if netId == originalNetId then
                local currentDistance = #(GetEntityCoords(ped) - GetEntityCoords(netVehicle))
                if currentDistance <= maxDistance then
                    TriggerClientEvent('WP:setPlate', playerId, netId, originalPlate, fakePlate, 'return')
                else
                    TriggerClientEvent('WC:notify', playerId, "error", 1000, nil, "Too far from vehicle.")
                end
            else
                TriggerClientEvent('WC:notify', playerId, "error", 1000, nil, "This plate doesn't belong to this vehicle.")
            end
        else
            TriggerClientEvent('WC:notify', playerId, "error", 1000, nil, "Vehicle already has this plate.")
        end
    end
end, Config.restrictCommands)

RegisterNetEvent('WP:getPlate', function(playerId, ped)
    local netVehicle    = GetVehiclePedIsIn(ped, true)
    originalNetId       = NetworkGetNetworkIdFromEntity(netVehicle)
    if not fakePlateActive then
        originalPlate   = GetVehicleNumberPlateText(netVehicle)
    end
    fakePlate           = Utils.generatePlate(2)

    local currentDistance = #(GetEntityCoords(ped) - GetEntityCoords(netVehicle))
    if currentDistance <= maxDistance then
        TriggerClientEvent('WP:setPlate', playerId, originalNetId, originalPlate, fakePlate, 'fake')
    else
        TriggerClientEvent('WC:notify', playerId, "error", 1000, nil, "Too far from vehicle.")
    end
end)

RegisterNetEvent('plateSuccess', function(cl_OriginalPlate, cl_FakePlate, plateType)
    if cl_OriginalPlate == originalPlate and cl_FakePlate == fakePlate then
        if plateType == 'fake' then
            fakePlateActive = true
            TriggerClientEvent('WC:notify', source, "success", 1000, nil, "Fake Plate Applied.")
            Utils.Debug('success', "^1[Fake]^2 Plate Applied.^7")
            Utils.Debug('success', "Vehicle plate set to: ^1["..cl_FakePlate.."]^7")
            -- Give Return Plate Item
            -- Remove Fake Plate
        elseif plateType == 'return' then
            fakePlateActive = false
            originalPlate   = nil
            originalNetId   = nil
            fakePlate       = nil
            TriggerClientEvent('WC:notify', source, "success", 1000, nil, "Original Plate Applied.")
            Utils.Debug('success', "^5[Original]^2 Plate Applied.^7")
            Utils.Debug('success', "Vehicle plate set to: ^5["..cl_OriginalPlate.."]^7")
            -- Give Fake Plate Item
            -- Remove Plate
        end
    else
        Utils.Debug('error', "The server plates is different from the client plates.")
        -- Add webhook since possible cheater.
    end
end)