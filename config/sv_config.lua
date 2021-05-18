Config                      = {}

Config.dropPlayer           = true -- Drops player if their client and server plates are not the same.
-- Config Variables (Database)
Config.useMysqlAsync        = true
Config.useGhmattimysql      = false
Config.Identifier           = 'license:'
Config.databaseName         = 'owned_vehicles'

-- Config Variables (Framework)
Config.Standalone           = true
Config.useESX               = false

-- Config Variables (Plates)
Config.ownerRestricted      = false -- Only allow vehicle owner to apply fake plate.
Config.restrictCommands     = false 
Config.allowMultipleFakes   = false -- Lets players use fake plates more than once.

-- Config Variables (Debug)
Debug                       = {}

Debug.debugLevel            = 3
--[[
    This sets the debug level which controls the prints you get in the console:
    0 - Disabled (Not Recomended)
    1 - Only errors
    2 - Errors and Success
    3 - Errors, Success and Informs (Everything)
]]
Debug.successDebugColor     = "^2"
Debug.informDebugColor      = "^5"
Debug.errorDebugColor       = "^1"
--[[
Example: Utils.Debug('error', "hello")
Debug Classess
"Error"
"Success"
"Inform"

^0 White
^1 Red
^2 Green
^3 Yellow
^4 Blue
^5 Light Blue
^6 Purple
^7 Default
^8 Dark Red
^9 Dark Blue
]]
