function onEnterRefillArea(player,sDimension)
	triggerClientEvent("onGasRefill",getRootElement(),true)
end
addEventHandler("onMarkerHit",getRootElement(),onEnterRefillArea)

function onExitRefillArea(playerplayer,sDimension)
		triggerClientEvent("onGasRefill",getRootElement(),false)
end
addEventHandler("onMarkerLeave",getRootElement(),onExitRefillArea)