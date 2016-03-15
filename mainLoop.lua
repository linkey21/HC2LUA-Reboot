--[[HC2-Reboot
	Dispositivo virtual
	mainLoop.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local release = {name='rebootVD', ver=1, mayor=1, minor=0}
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
while true do
  response ,status, errorCode = HC2:GET("/api/diagnostics")
  local memoryFree = json.decode(response)['memory'].free
  local memoryMin = tonumber(string.sub(fibaro:get(_selfId, "ui.memoryLabel.value"), 7, 8))
  -- si aún no se a inicializado
  if not memoryMin then
    -- escribir la etiqueta inicial
    fibaro:call(_selfId, "setProperty", "ui.memoryLabel.value", memoryFree..'% / 10%')
  end
    -- comprobar si la memoria está por debajo de ma memoria mínima
  if memoryFree < memoryMin then
    --si se ha definido un dispositivo para push, enviar mensaje
    local pushId = fibaro:get(_selfId, "ui.devLabel.value")
    pushId = string.sub(pushId, 1, string.find(pushId, '-') - 1)
    if pushId ~= '' then
      pushId = tonumber(pushId)
      fibaro:call(pushId, 'sendPush', 'Memoria baja, reiniciando HC2')
    end
    -- reiniciar invocando el botón rebootButton
    fibaro:call(_selfId, 'pressButton', '6')
  end
  memoryMin = string.format('%02d', memoryMin)
  memoryFree = string.format('%02d',memoryFree)
  fibaro:log('Memoria Libre: '..memoryFree..'%')
  fibaro:call(_selfId, "setProperty", "ui.memoryLabel.value",
    memoryFree..'% / '..memoryMin..'%')
  fibaro:sleep(2000)
  fibaro:log('')
  -- para control por whatchdog
  fibaro:debug(release['name']..' OK')
end
