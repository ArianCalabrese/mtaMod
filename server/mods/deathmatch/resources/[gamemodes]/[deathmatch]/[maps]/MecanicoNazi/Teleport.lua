local posicoes =
    {
        {  2125.69458, -1891.04456 ,13.32104 },
    }
	
function PosicaoPlayer ( thePlayer, command )
    local azar = math.random ( #posicoes )
	local veh = getPedOccupiedVehicle(thePlayer)
		if (veh) then
			setElementPosition(veh, unpack ( posicoes [ azar ] ) )
		else
			setElementPosition(thePlayer, unpack ( posicoes [ azar ] ) )
		end	
			outputChatBox ( "Fuiste al taller mecanico",source, 0, 255, 0, true )
end
addCommandHandler ( "tallermecanico", PosicaoPlayer  )
