ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        print("got  ESX object on server")
        ESX = obj
    end
)

AddEventHandler(
    "playerConnecting",
    function(playerName, setKickReason, deferrals)
        local playerId, identifier = source

        for l, v in ipairs(GetPlayerIdentifiers(playerId)) do
            if string.match(v, "license:") then
                identifier = string.sub(v, 9)
                break
            end
        end
        if identifier then
            MySQL.Async.fetchScalar(
                'SELECT * FROM users WHERE identifier like "' .. identifier .. '%"',
                {},
                function(result)
                    print("triggering mx-character event")
                    -- loadESXPlayer(identifier, playerId)
                    -- load player select with characters
                    SendNUIMessage(json.encode(result))

                    -- load player select with no characters
                    -- MySQL.Async.execute(
                    --     "INSERT INTO users (identifier) VALUES (@identifier)",
                    --     {
                    --         ["@identifier"] = identifier
                    --     },
                    --     function(rowsChanged)
                    --         loadESXPlayer(identifier, playerId)
                    --     end
                    -- )
                end
            )
        end
    end
)
RegisterServerEvent("loadCharacters")
AddEventHandler(
    "loadCharacters",
    function(characters)
        print("Going to send NUI Message")
        -- array of chars from the database
        SendNuiMessage(json.encode(characters))
    end
)

function generateSSN()
    local area, group, serial

    while true do
        area = chance.basic.string {length = 3, group = "digit"}
        if not area:match("000") and not area:match("9%d%d") then
            break
        end
    end

    while true do
        group = chance.basic.string {length = 2, group = "digit"}
        if not group:match("00") then
            break
        end
    end

    while true do
        serial = chance.basic.string {length = 4, group = "digit"}
        if not serial:match("0000") then
            break
        end
    end

    return string.format("%s-%s-%s", area, group, serial)
end

RegisterServerEvent("mx-characters:createCharacter")
AddEventHandler(
    "mx-characters:createCharacter",
    function(character)
        local ssn = generateSSN()
        MySQL.Async.execute(
            "INSERT INTO users (identifier, ssn, job, job_grade, first_name, last_name, dob, height,) VALUES (@identifier, @ssn, @job, @job_grade, @first_name, @last_name, @dob, @height)",
            {
                ["@identifier"] = data.identifier .. "::" .. ssn,
                ["@ssn"] = generateSSN(),
                ["@job"] = data.job,
                ["@job_grade"] = data.job_grade,
                ["@first_name"] = data.first_name,
                ["@last_name"] = data.last_name,
                ["@dob"] = data.dob,
                ["@height"] = data.height
            },
            function(rowsChanged)
                TriggerClientEvent("mx-characters:characterCreated", identifier, source)
                -- ESX.loadPlayer(identifier, source)
            end
        )
    end
)
