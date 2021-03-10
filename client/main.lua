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
        print("got the client event")
        print(playerId)
        print(characters)
        print(json.encode(characters))
        Citizen.CreateThread(
            function()
                if characters then
                    sendNUIMessage(json.encode({characters = characters}))
                else
                    SendNUIMessage({characters = nil})
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
