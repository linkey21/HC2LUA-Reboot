--[[HC2-Reboot
	Dispositivo virtual
	rebootButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end

HC2:POST('/api/settings/reboot', 'HTTP/1.1')
