fx_version "cerulean"
game "gta5"
description "mx-characters"

client_scripts {
    "client/main.lua"
}

server_scripts {
    "server/main.lua",
    "@mysql-async/lib/MySQL.lua"
}
