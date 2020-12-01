--[[NPC]]--
local npc = {
  {249.53164672852,-1358.892578125,23.5,"Domnu Doctor",265.0,0xD47303AC,"s_m_m_doctor_01"} -- npc ped
}

Citizen.CreateThread(function()
  for _,v in pairs(npc) do
    RequestModel(GetHashKey(v[7]))
    while not HasModelLoaded(GetHashKey(v[7])) do
      Wait(1)
    end
    RequestAnimDict("anim@heists@humane_labs@finale@strip_club")
    while not HasAnimDictLoaded("anim@heists@humane_labs@finale@strip_club") do -- npc animation
      Wait(1)
    end
    ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
    SetEntityHeading(ped, v[5])
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskPlayAnim(ped,"anim@heists@humane_labs@finale@strip_club","ped_b_celebrate_loop", 8.0, 0.0, -1, 1, 0, 0, 0, 0) -- npc animation
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      local pos = GetEntityCoords(GetPlayerPed(-1), true)
      for _,v in pairs(npc) do
          x = v[1]
          y = v[2]
          z = v[3]
          if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 20.0)then
              DrawText3D(x,y,z+1.95, "~w~[Doctor]", 1.0, 1) --text above npc
          end
      end
  end
end)

--[[CLIENT]]--
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      local ped = PlayerPedId()
      local currentPos = GetEntityCoords(ped)
      health = GetEntityHealth(ped)
      for _,v in pairs(npc) do
        x = v[1]
        y = v[2]
        z = v[3]
        if GetDistanceBetweenCoords(currentPos, x, y, z, true) <= 1.5 then
          if health >= 170 then 
            alert("You don't need a treatment, you are healthy!") -- you helth is to high
          else
          alert("Press ~INPUT_PICKUP~ to get a treatment \nPrice: 500$")
          if (IsControlJustPressed(1,38)) and (GetDistanceBetweenCoords(currentPos, x, y, z, true) <= 1.5) then
            notify("~b~A doctor is taking care of you...")
            SetEntityCoords(ped, 249.24031066895,-1355.4969482422,25.554397583008) -- where the ped will tp (deefault the operation table)
            TaskPlayAnim(ped,"timetable@tracy@sleep@","idle_c", 8.0, 0.0, -1, 1, 0, 0, 0, 0) -- emote
            Wait(30000) -- it will wait 30 seconds (30 000 miliseconds)
            ClearPedTasksImmediately(ped) -- clear emote
            TriggerServerEvent('hospital:heal') -- server event
          end
        end
      end
    end
  end
end)


--[[OTHER THINGS]]--
function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true,false)
end

function DrawText3D(x,y,z, text, scl, font) 
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
  local scale = (1/dist)*scl
  local fov = (1/GetGameplayCamFov())*100
  local scale = scale*fov
 
  if onScreen then
      SetTextScale(0.0*scale, 1.1*scale)
      SetTextFont(font)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
  end
end
