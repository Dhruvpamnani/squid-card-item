local opened = false
local object = 0
local isUiOpen = false 
local TestLocalTable = {}


Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

--[[RegisterCommand('squid-number', function(s,a,r)
    local newNum = a[1]
    if newNum then 
        local len = string.len(newNum)
        if len <= 10 and len > 0 then
            SendNUIMessage({
                action = "newnumber",
                number = newNum,
            })
        else
            exports["mythic_notify"]:SendAlert('error', 'The number must be between 1 - 10 numbers.')
        end
    else
        exports["mythic_notify"]:SendAlert('error', 'You must enter a new number for the card.')
    end
end)]]--

--[[RegisterCommand('squid-card', function(s,a,r)
    if not opened then
        SendNUIMessage({
            action = "show"
        })
        SetNuiFocus(true, true)
    else
        SendNUIMessage({
            action = "close"
        })
        SetNuiFocus(false, false)
    end
end)]]--

RegisterNUICallback("closeCard",function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNetEvent("squid-card:OpenCardGui")
AddEventHandler("squid-card:OpenCardGui", function()
    if not isUiOpen then
        openGui()
    end
end)



RegisterNUICallback('closeCard', function(data, cb)
    local text = data.text
    TriggerEvent("squid-card:CloseCard")
end)


RegisterNUICallback('updating', function(data, cb)
    local text = data.text
    TriggerServerEvent("server:updateCard",editingNotpadId, text)
    editingNotpadId = nil
    TriggerEvent("squid-card:CloseCard")
end)

RegisterNetEvent("squid-card:CloseCard")
AddEventHandler("squid-card:CloseCard", function()
    SendNUIMessage({
        action = 'close'
    })
    SetPlayerControl(PlayerId(), 1, 0)
    isUiOpen = false
    SetNuiFocus(false, false);
    TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(100)
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(prop, 1, 1)
    DeleteObject(prop)
    DetachEntity(secondaryprop, 1, 1)
    DeleteObject(secondaryprop)
end)


RegisterNetEvent('squid-card:updateCard')
AddEventHandler('squid-card:updateCard', function(serverCardPassed)
    TestLocalTable = serverCardPassed
end)

function openGui() 
    local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))  
    if GetPedInVehicleSeat(veh, -1) ~= GetPlayerPed(-1) then
        SetPlayerControl(PlayerId(), 0, 0)
        SendNUIMessage({
            action = 'show',
        })
        isUiOpen = true
        SetNuiFocus(true, true);
    end
end

function openGuiRead(text)
  local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
  if GetPedInVehicleSeat(veh, -1) ~= GetPlayerPed(-1) then
        SetPlayerControl(PlayerId(), 0, 0)
        TriggerEvent("squid-card:card")
        isUiOpen = true
        Citizen.Trace("OPENING")
        SendNUIMessage({
            action = 'show',
            --TextRead = text,--
        })
        SetNuiFocus(true, true)
  end  
end


RegisterNetEvent('squid-card:card')
AddEventHandler('squid-card:card', function()
    local player = PlayerPedId()
    local ad = "missheistdockssetup1clipboard@base"
                
    local prop_name = prop_name or 'prop_cs_r_business_card'
    --local secondaryprop_name = secondaryprop_name or 'prop_cs_business_card'--
    
    if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
        loadAnimDict( ad )
        if ( IsEntityPlayingAnim( player, ad, "base", 3 ) ) then 
            TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            Citizen.Wait(100)
            ClearPedSecondaryTask(PlayerPedId())
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            DetachEntity(secondaryprop, 1, 1)
            DeleteObject(secondaryprop)
        else
            local x,y,z = table.unpack(GetEntityCoords(player))
            prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
            secondaryprop = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true) 
            --AttachEntityToEntity(secondaryprop, player, GetPedBoneIndex(player, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true) --
            TaskPlayAnim( player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        end     
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end