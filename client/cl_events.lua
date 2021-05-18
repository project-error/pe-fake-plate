if Config.esxNotify then
    ESX = exports['es_extended']:getSharedObject()
end

local inProgress = false

RegisterNetEvent('NFPWD:setPlate', function(netId, originalPlate, fakePlate, plateType)
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
                    RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                    if not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") then
                        Wait(100)
                    end
                    TriggerEvent('NFPWD:notifySuccess', 'Applying plate...')
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
                        TriggerEvent('NFPWD:notifyError', 'Animation was cancelled.')
                        inProgress = false
                    end
                end
            else
                TriggerEvent('NFPWD:notifyError', 'Action already in progress.')
            end
        else
            print("Triggered without args")
            -- Should be impossible to do.
        end
    else
        print("Tried to access invalid network ID")
    end
end)

RegisterNetEvent('NFPWD:notifySuccess')
AddEventHandler('NFPWD:notifySuccess', function(message)
    length = Config.successLength * 1000
    if Config.tNotify then 
        exports['t-notify']:Alert({
            style  =  'success',
            message  =  "✔️ " .. message,
            length = length
        })
    end
    if Config.mythicNotify then
        exports['mythic_notify']:SendAlert('success', "✔️ " .. message, length)
    end
    if Config.pNotify then
        exports.pNotify:SetQueueMax(id, 1)
        exports.pNotify:SendNotification({
            text = "✔️ " .. message,
            type = "success",
            timeout = length,
            layout = Config.layout,
            theme = Config.theme,
            queue = "id"
        })
    end
    if Config.esxNotify then
        ESX.ShowNotification(
            "✔️ " .. message, 
            false, 
            false, 
            140
        )
    end
end)

RegisterNetEvent('NFPWD:notifyError')
AddEventHandler('NFPWD:notifyError', function(message)
    length = Config.errorLength * 1000
    if Config.tNotify then 
        exports['t-notify']:Alert({
            style  =  'error',
            message  =  "❌ " .. message,
            length = length
        })
    end
    if Config.mythicNotify then
        exports['mythic_notify']:SendAlert('error', "❌ " .. message, length)
    end
    if Config.pNotify then
        exports.pNotify:SetQueueMax(id, 1)
        exports.pNotify:SendNotification({
            text = "❌ " .. message,
            type = "error",
            timeout = length,
            layout = Config.layout,
            theme = Config.theme,
            queue = "id"
        })
    end
    if Config.esxNotify then
        ESX.ShowNotification(
            "❌ " .. message, 
            false, 
            false, 
            140
        )
    end
end)