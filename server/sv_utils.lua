Utils = {}

Utils.Debug = function(class, message)
    if Debug.debugLevel >= 1 then
        if class == "error" and Debug.debugLevel >= 1 then
            print(Debug.errorDebugColor.."[ERROR]:".. message .. "^7")
        elseif class == "success" and Debug.debugLevel >= 2 then
            print(Debug.successDebugColor.."[SUCCESS]:".. message .. "^7")
        elseif class == "inform" and Debug.debugLevel == 3 then
            print(Debug.informDebugColor.."[INFO]:".. message .. "^7")
        elseif class ~= "error" and class ~= "success" and class ~= "inform" then
            print("^1  [ERROR]: Invalid Debug Class: ^0".. class .. "^1 Please use 'error', 'success' or 'inform'.^7")
        end
    end
end

Utils.getPlayerIdentifier = function(source)
    local identifier
    for k, v in ipairs(GetPlayerIdentifiers(source)) do 
		if string.match(v, Config.Identifier) then
			identifier = v
			break
		end
    end
    return identifier
end

Utils.generatePlate = function(length) -- 2 is 8 char
    local sequence = ""
    for i = 1, length do
        sequence = ""..sequence..Utils.randomLetter()..math.random(111,999)..""
    end
    return sequence
end

Utils.randomLetter = function()
    local rLetter = string.char(math.random(65,  90))
        rLetter = math.random() > .5 and rLetter:upper() or rLetter
    return rLetter
end

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		local resourceName = "^4["..GetCurrentResourceName().."]^2"

		Utils.Debug('success', " " .. resourceName .. " has started.^7")
	end
end)