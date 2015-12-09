--[[HC2-Reboot
	Dispositivo virtual
	upButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

local _selfId = fibaro:getSelfId()
local memoryString = fibaro:get(_selfId, "ui.memoryLabel.value")
local memoryMin = tonumber(string.sub(memoryString, 7, 8))
if memoryMin < 99 then
  memoryMin = memoryMin + 1
else
  memoryMin = 1
end
memoryMin = string.format('%02d', memoryMin)
memoryString = string.sub(memoryString, 1, 6)..memoryMin..'%'
fibaro:debug(memoryString)
fibaro:call(_selfId, "setProperty", "ui.memoryLabel.value",
    memoryString)
