local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_treatment")

--[[EVENTS]]--
RegisterServerEvent("hospital:heal")
AddEventHandler("hospital:heal", function()
  local user_id = vRP.getUserId({source})
  local chance = math.random(1,2)
  if chance == 2 then
    vRPclient.notify(user_id,{"~r~Doctors couldn't save you, go to another Hospital! \n~h~You didn't pay!"})
  else
    if vRP.tryFullPayment({user_id,500}) then
  vRPclient.varyHealth(user_id,{100})
  vRPclient.notify(user_id,{"~g~The Doctors treated you and you feel 100 times better! \n~h~You payed them 500$!"})
    else
      vRPclient.notify(user_id,{"~g~You didn't have 500$ so Doctors couldn't treat you!"})
  end
end
end)