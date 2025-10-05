name "md-houserobberies v2"
author "Mustache Dom"
description "Steal Things From Houses"
fx_version 'cerulean'
game 'gta5'
version '3.0.0'

shared_scripts {
    'Shared/**.lua',
    '@ox_lib/init.lua',
}

client_script {
   'client/**.lua',
}
server_script {
    'server/server_config.lua',
    'server/main.lua',
}

files {
    'locales/**.lua',
}
lua54 'yes'
