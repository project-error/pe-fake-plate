CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/fakePlate', 'Apply fake plate to your last entered vehicle.')
    TriggerEvent('chat:addSuggestion', '/returnPlate', 'Restore your plate to its original text.')
end)