local inProgress = false

RegisterNetEvent('WP:setPlate', function(netId, originalPlate, fakePlate, plateType)
    if NetworkDoesEntityExistWithNetworkId(netId) then
        local vehicle = NetToVeh(netId)
        if fakePlate ~= nil and originalPlate ~= nil then
            if not inProgress then
                inProgress = true
                if Config.mythicProgressBar then
                    exports['mythic_progbar']:Progress({
                        name = "firstaid_action",
                        duration = 8000,
                        label = "Changing plate...",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                            anim = "machinic_loop_mechandplayer",
                            flags = 1,
                        },
                    }, function(status)
                        if not status then
                            if plateType == 'fake' then
                                SetVehicleNumberPlateText(vehicle, fakePlate)
                                TriggerServerEvent('plateSuccess', originalPlate, fakePlate, plateType)
                            elseif plateType == 'return' then
                                SetVehicleNumberPlateText(vehicle, originalPlate)
                                TriggerServerEvent('plateSuccess', originalPlate, fakePlate, plateType)
                            end
                            inProgress = false
                        else
                            inProgress = false
                        end
                    end)
                else
                    RequestAnimDict(animDict)
                    if not HasAnimDictLoaded(animDict) then
                    Wait(100)
                    end
                    TriggerEvent('WC:notify', "message", 7000, nil, "Applying plate")
                    TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0, 1.0, 8000, 1, 0, false, false, false)
                    Wait(7500)
                    if IsEntityPlayingAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1) then
                        if plateType == 'fake' then
                            SetVehicleNumberPlateText(vehicle, fakePlate)
                            TriggerServerEvent('plateSuccess', originalPlate, fakePlate, plateType)
                        elseif plateType == 'return' then
                            SetVehicleNumberPlateText(vehicle, originalPlate)
                            TriggerServerEvent('plateSuccess', originalPlate, fakePlate, plateType)
                        end
                        inProgress = false
                    else
                        TriggerEvent('WC:notify', "error", 1000, nil, "Animation was canceled.")
                        inProgress = false
                    end
                end
            else
                TriggerEvent('WC:notify', "error", 1000, nil, "You're already doing this!")
            end
        else
            print("Triggered without args")
            -- Should be impossible to do.
        end
    else
        print("Tried to access invalid network ID")
    end
end)