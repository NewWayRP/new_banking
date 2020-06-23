--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX                         = nil
inMenu                      = true
local showblips = false
local atbank = false
local bankMenu = true
local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
  {name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=108, x=241.727, y=220.706, z=106.286},
    {name="Bank", id=108, x=1115.66, y=219.27, z=-49.44},
  {name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}

  local atmModels = {
    [-1126237515] = true,
    [506770882] = true,
    [-1364697528] = true,
    [-870868698] = true,
}

--================================================================================================
--==                                THREADING - DO NOT EDIT                                     ==
--================================================================================================

--===============================================
--==           Base ESX Threading              ==
--===============================================
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)





--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
  Citizen.CreateThread(function()
    local waitTime = 500
  while true do
   Citizen.Wait(waitTime)
  if nearBank() or nearATM() then
	waitTime = 1
      DisplayHelpText("Press ~INPUT_PICKUP~ to access account ~b~")
    
    if IsControlJustPressed(1, 38) then
      inMenu = true
      SetNuiFocus(true, true)
      SendNUIMessage({type = 'openGeneral'})
      TriggerServerEvent('bank:balance')
      local ped = GetPlayerPed(-1)
    end
   else
	waitTime = 500
   end

    if IsControlJustPressed(1, 322) then
    inMenu = false
      SetNuiFocus(false, false)
      SendNUIMessage({type = 'close'})
    end
  end

  end)
end


--===============================================
--==             Map Blips                     ==
--===============================================
Citizen.CreateThread(function()
  if showblips then
    for k,v in ipairs(banks)do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite(blip, v.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring(v.name))
    EndTextCommandSetBlipName(blip)
    end
  end
end)

Citizen.CreateThread(function()
  if showblips then
    for k,v in ipairs(atms)do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite(blip, v.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring(v.name))
    EndTextCommandSetBlipName(blip)
    end
  end
end)


--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
  local id = PlayerId()
  local playerName = GetPlayerName(id)

  SendNUIMessage({
    type = "balanceHUD",
    balance = balance,
    player = playerName
    })
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
  TriggerServerEvent('bank:deposit', tonumber(data.amount))
  TriggerServerEvent('bank:balance')
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
  TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
  TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
  TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
  SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
  TriggerServerEvent('bank:transfer', data.to, data.amountt)
  TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
  SendNUIMessage({type = 'result', m = message, t = type})
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
  local player = GetPlayerPed(-1)
  local playerloc = GetEntityCoords(player, 0)

  for _, search in pairs(banks) do
    local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

    if distance <= 3 then
      return true
    end
  end
end



function nearATM()
  local player = PlayerPedId()
  local playerLoc = GetEntityCoords(player, 0)

  for foundatm, _  in pairs(atmModels) do

    ATMObject = GetClosestObjectOfType(playerLoc, 0.8, foundatm, false)

    if DoesEntityExist(ATMObject) then
      atmModel = foundatm

            return true
    end
  end
  return false
end


function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
