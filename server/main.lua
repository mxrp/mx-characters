ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        print("got  ESX object on server")
        ESX = obj
    end
)

RegisterServerEvent("loadCharacters")
AddEventHandler(
    "loadCharacters",
    function(playerId, characters)
        -- array of chars from the database
        print("Triggering client event")
        print(playerId)
        print(characters)
        TriggerClientEvent("mx-characters:loadCharacters", playerId, characters)
        -- SendNuiMessage(json.encode(characters))
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
