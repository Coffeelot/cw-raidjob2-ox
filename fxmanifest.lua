fx_version 'cerulean'

game 'gta5'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/*.lua',
    'config.lua',
}

client_scripts{
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/*.lua',
}

server_scripts{
    'server/*.lua',
}

dependency 'ps-ui'