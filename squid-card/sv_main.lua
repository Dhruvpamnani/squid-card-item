QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent('server:LoadsCard')

QBCore.Functions.CreateUseableItem('squid-card', function(source)
   local _source  = source
   local xPlayer   = QBCore.Functions.GetPlayer(_source)
   TriggerClientEvent('squid-card:card', _source)
    TriggerClientEvent('squid-card:OpenCardGui', _source)
    --xPlayer.removeInventoryItem('squid-card', 0)--
   Citizen.Wait(100)

 end)


RegisterNetEvent("server:LoadsCard")
AddEventHandler("server:LoadsCard", function()
   TriggerClientEvent('squid-card:updateCard', -1, savedNotes)
end)

RegisterNetEvent("server:updateCard")
AddEventHandler("server:updateCard", function(noteID, text)
--  savedNotes[noteID]["text"]=text--
  TriggerEvent("server:LoadsCard")
end)

