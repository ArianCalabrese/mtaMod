local posicoes =
    {
        { 1791.0500488281, -1883.5491943359, 14 },
        { 1796.2043457031, -1883.5491943359, 14 },
        { 1801.9278564453, -1883.5491943359, 14 },
    }
	
function PosicaoPlayer ( thePlayer, command )
    local azar = math.random ( #posicoes )
	local veh = getPedOccupiedVehicle(thePlayer)
	if (veh) then
		outputChatBox ("Você não pode usar este teleporte com veículo.", thePlayer, 255, 150, 0)
	else
		setElementPosition(thePlayer, unpack ( posicoes [ azar ] ) )
		outputChatBox ('#FFFF00Empregos: #ffffff' .. getPlayerName(thePlayer) .. ' #fffffffoi trabalhar como taxista. #FFFF00/trab2', root, 255, 255, 255, true)
	end	
end
addCommandHandler ( "trab2", PosicaoPlayer  )