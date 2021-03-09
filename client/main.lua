ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            Citizen.Wait(200)
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
        end
    end
)

RegisterNuiCallback(
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
