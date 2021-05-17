fx_version 'cerulean'

game { 'gta5' }

description 'Reanimation Weeb Plate'

version '1.0.0'

lua54 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config/sv_config.lua',
	'server/*.lua',
}

client_scripts {
	'config/cl_config.lua',
	'client/*.lua',
}

dependencies { 
	'mysql-async'
 }
