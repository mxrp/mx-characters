ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            Citizen.Wait(200)
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    print("GOT ESX OBJECT")
                    ESX = obj
                end
            )
        end
    end
)

RegisterNetEvent(
    "mx-characters:loadCharacters",
    function(playerId, characters)
        Citizen.CreateThread(
            function()
                -- DoScreenFadeOut(10)
                -- while not IsScreenFadedOut() do
                --     Citizen.Wait(10)
                -- end
                SetTimecycleModifier("hud_def_blur")
                FreezeEntityPosition(GetPlayerPed(-1), true)
                cam =
                    CreateCamWithParams(
                    "DEFAULT_SCRIPTED_CAMERA",
                    -1355.93,
                    -1487.78,
                    520.75,
                    300.00,
                    0.00,
                    0.00,
                    100.00,
                    false,
                    0
                )
                SetCamActive(cam, true)
                RenderScriptCams(true, false, 1, true, true)
                if characters then
                    SetNuiFocus(true, true)
                    DisplayHud(false)
                    DisplayRadar(false)
                    sendNUIMessage(json.encode({characters = characters, action = "openui"}))
                else
                    DisplayHud(false)
                    DisplayRadar(false)
                    SetNuiFocus(true, true)
                    SendNUIMessage({characters = nil, action = "openui"})
                end
            end
        )

        -- SendNUIMessage(json.encode(characters))
    end
)

RegisterNUICallback(
    "createCharacter",
    function(data, cb)
        -- data is the Created Character
        TriggerServerEvent("mx-characters:createCharacter", character)
    end
)

RegisterNetEvent(
    "mx-characters:characterCreated",
    function(identifier, source)
        ESX.loadPlayer(identifier, source)
    end
)
