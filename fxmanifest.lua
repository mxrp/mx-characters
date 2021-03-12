fx_version "cerulean"
game "gta5"

description "mx-characters"

client_script "client/main.lua"
ui_page("html/index.html")

server_scripts {
    "server/main.lua"
}

files(
    {
        "html/index.html",
        "html/app.css",
        "html/app.js"
    }
)
