--[[HC2-Reboot
	Dispositivo virtual
	upDevButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
response ,status, errorCode = HC2:GET("/api/devices?type=iOS_device")

local selectDev = fibaro:get(_selfId, "ui.devLabel.value")
local myKey = 1
local devs = json.decode(response)
table.insert(devs, {id = '', name = 'No avisar'})
for key, value in pairs(devs) do
  if value.id..'-'..value.name == selectDev then
      if key < #devs then myKey = key + 1 else myKey = 1 end
    break
  else
    myKey = #devs
  end
end
fibaro:call(_selfId, "setProperty", "ui.devLabel.value",
 devs[myKey].id..'-'..devs[myKey].name)
