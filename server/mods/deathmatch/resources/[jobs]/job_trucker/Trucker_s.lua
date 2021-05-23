local TruckerTeam = createTeam("Trucker", 20, 100, 150)
	
	removeWorldModel (985 , 7.3802581, 2497.2419, 2774.2747, 10.7167)
    removeWorldModel (986, 7.4280729, 2497.2119, 2768.4243, 11.38819)
	RGate = createObject (986, 2497.3999, 2769.0991, 11.53, 0, 0, 90)
    LGate = createObject (985, 2497.3999, 2777.0701, 11.53, 0, 0, 90)
	ColGate = createColCuboid (2487.15, 2765.28, 10, 20, 15.75, 5)

function KACC_Open ( thePlayer, matchingDimension )
    if getElementType ( thePlayer ) == "player" then --if the element that entered was player
		moveObject(RGate, 1000, 2497.3999, 2769.0991-5, 11.53, 0, 0, 0)
		moveObject(LGate, 1000, 2497.3999, 2777.0701+5, 11.53, 0, 0, 0)
    end
end

addEventHandler ( "onColShapeHit", ColGate, KACC_Open )	

function KACC_Close ( thePlayer, matchingDimension )
    if getElementType ( thePlayer ) == "player" then --if the element that entered was player
		if not isElementWithinColShape ( thePlayer, ColGate ) then
			moveObject (RGate, 1000, 2497.3999, 2769.0991, 11.53, 0, 0, 0)
			moveObject (LGate, 1000, 2497.3999, 2777.0701, 11.53, 0, 0, 0)	
		end
    end
end

addEventHandler ( "onColShapeLeave", ColGate, KACC_Close )

--[[Remove gates in LV
    removeWorldModel (985 , 7.3802581, 2497.2419, 2774.2747, 10.7167)
    removeWorldModel (986, 7.4280729, 2497.2119, 2768.4243, 11.38819)
    --createObject (986, 2493.3999, 2766.7, 11.53, 0, 0, 160)
	--createObject (985, 2493.3999, 2779.6, 11.53, 0, 0, 20)
	RGate = createObject (986, 2497.3999, 2769.0991, 11.53, 0, 0, 90)
    LGate = createObject (985, 2497.3999, 2777.0701, 11.53, 0, 0, 90)
	ColGate = createColCuboid (2487.15, 2765.28, 10, 20, 15.75, 5)

isGateOpen = false
local OpenTimer
local CloseTimer

function KACC_Open ( thePlayer, matchingDimension )
    if getElementType ( thePlayer ) == "player" then --if the element that entered was player
		if isTimer(OpenTimer) then
			outputChatBox("Timer Found",thePlayer)
		end
		if isGateOpen == false then
			x,y,z = getElementRotation(LGate)
			if not z == 20 then
				return
			end
			moveObject(RGate, 1500, 2493.3999, 2766.7, 11.53, 0, 0, 70)
			moveObject(LGate, 1500, 2493.3999, 2779.6, 11.53, 0, 0, -70)
			OpenTimer = setTimer(function() isGateOpen = true end,2000,1)
		end	
    end
end

addEventHandler ( "onColShapeHit", ColGate, KACC_Open )	

function KACC_Close ( thePlayer, matchingDimension )
    if getElementType ( thePlayer ) == "player" then --if the element that entered was player
		if isGateOpen == true then
			x,y,z = getElementRotation(LGate)
			if not z == 90 then
				return
			end
			moveObject (RGate, 1500, 2497.3999, 2769.0991, 11.53, 0, 0, -70)
			moveObject (LGate, 1500, 2497.3999, 2777.0701, 11.53, 0, 0, 70)
			CloseTimer = setTimer(function() isGateOpen = false end,2000,1)
		end	
    end
end

addEventHandler ( "onColShapeLeave", ColGate, KACC_Close )]]


TruckerMarker = {--marker [x,y,z]   truck spawn point: [x,y,z,rotationx,rotationy,rotationz], [location]
{2179.841796875, -2263.6940917969, 13.8, 2167.4401855469, -2273.9362792969, 14 ,-0, 0, 220, "Ocean Docks"},
{-1737.9622802734, 20.285757064819, 2.7, -1710, 10, 4, 0, 0, 315, "Easter Basin"},
{1643, 2354, 10, 1634, 2365, 11, -0, 0, 90, "Redsands West"}
}--Above table is for the job markers, player walks into one, they become trucker and a truck is spawned, read above comment for info on spawning trucks.

Handler = false --DO NOT CHANGE, WILL NOT WORK IF IT'S NOT SET TO FALSE
timer = true --If your server has a script to automatically destroy vehicles when they explode you should set this to true
local isTrailerDetached = false --DO NOT CHANGE, WILL NOT WORK IF IT'S NOT SET TO FALSE
local markerStore = {} --Stores markers

function TruckerStart ( hitElement, matchingDimension )
	if isElement(hitElement) and getElementType(hitElement) == "player" and matchingDimension then
		if not (isGuestAccount (getPlayerAccount (hitElement))) then --First we want to check if player has made any shipments, if so, set there shipment data!
		local account = getPlayerAccount (hitElement)
			if (account) then
			local PlayerShipments = getAccountData( account, "Trucker.pres" )
				if (PlayerShipments) then
					setElementData (hitElement, "Trucker.pres", PlayerShipments)
				else
					setElementData (hitElement, "Trucker.pres", 0)
				end
				local marker_data = markerStore[source] --We get the marker data from an empty table, you will see why we do this in below function
				if marker_data then
					--outputDebugString("Marker data found: "..tostring(marker_data))
					triggerClientEvent ( hitElement, "spawnTruck", hitElement, marker_data)
				end
			end
		end
	end
end

function spawnNo(hitElement) --If player choses no in client side GUI, then they won't get a truck
	if isElement(hitElement) and getElementType(hitElement) == "player" then
		if ( TruckerTeam ) then --Then we want to check if the trucker team exists
			if isPedOnGround ( hitElement ) then --If so, check if player is on foot
				local playerTeam = getPlayerTeam ( hitElement ) --Get there team         
				if not ( playerTeam == TruckerTeam) then --If they are not on the trucker team
					setPlayerTeam(hitElement, TruckerTeam) --Set there team
				end
					triggerClientEvent ( hitElement, "destroyIron", hitElement) --Oherwise, we make the markers for them to get there goods	
					triggerClientEvent ( hitElement, "shipmentMarker", hitElement) --Oherwise, we make the markers for them to get there goods	
			else 
				outputChatBox("You must be on foot!", hitElement, 255, 0, 0)
			end
		end 
	end
end

addEvent("spawnTruckNo", true)
addEventHandler("spawnTruckNo", getRootElement(), spawnNo)

addEvent("spawnTruckYes", true)
addEventHandler("spawnTruckYes", root, 
function (hitElement, marker_data)--If player choses yes in client side GUI, then they will get a truck
	if isElement(hitElement) and getElementType(hitElement) == "player" then
		if ( TruckerTeam ) then --Then we want to check if the trucker team exists
			if isPedOnGround ( hitElement ) then --If so, check if player is on foot
				local playerTeam = getPlayerTeam ( hitElement ) --Get there team         
				if not ( playerTeam == TruckerTeam) then --If they are not on the trucker team
					setPlayerTeam(hitElement, TruckerTeam) --Set there team
				end
						triggerClientEvent ( hitElement, "destroyIron", hitElement)
						triggerClientEvent ( hitElement, "shipmentMarker", hitElement)
						local x, y, z, rx, ry, rz, name
						if marker_data then
							x,y,z,rx,ry,rz,name = marker_data[4],marker_data[5],marker_data[6],marker_data[7],marker_data[8],marker_data[9],marker_data[10]
						local spawnedTruck = getElementData( hitElement, "Trucker.truck" ) --Now we want to check if they have spawned a truck
						if ( spawnedTruck ~= false ) then --(~= is not equal)
							if isElement(spawnedTruck) then
								destroyElement(spawnedTruck) --If they have, destroy the truck
							end
							setElementData(hitElement, "Trucker.truck", false) --And set there data to false
						end
						local spawnedTrailer = getElementData( hitElement, "Trucker.trailer" )	
						if ( spawnedTrailer ~= false ) then 
							if isElement(spawnedTrailer) then
								destroyElement(spawnedTrailer)
							end
							setElementData(source, "Trucker.trailer", false) 
						end
							local Truck = createVehicle (515, x, y, z+1, rx, ry, rz)  
							setElementData(hitElement, "Trucker.truck", Truck)
							warpPedIntoVehicle (hitElement, Truck)
							--[[This can give faster trucks, but not recommended.
							setVehicleHandling( Truck, "engineAcceleration", "20" )
							setVehicleHandling( Truck, "maxVelocity", "150" )
							setVehicleHandling( Truck, "steeringLock", "40" )
							setVehicleHandling( Truck, "brakeDeceleration", "10000" )
							setVehicleHandling( Truck, "engineType", "petrol" )
							setVehicleHandling( Truck, "driveType", "awd" )	
							Truck = false]]
						end  
			else 
				outputChatBox("You must be on foot!", hitElement, 255, 0, 0)
			end
		end 
	end
end)


function createMarkers()
    for i=1,#TruckerMarker do 
        local x,y,z = TruckerMarker[i][1],TruckerMarker[i][2],TruckerMarker[i][3]--x = key 1, y = key 2, z = key 3		
		local marker = createMarker( x,y,z,"cylinder", 1, 0, 200, 55, 255 )
		markerStore[marker] = TruckerMarker[i]
		TruckerJobBlip = createBlipAttachedTo ( marker, 42, 2, 0, 0, 0, 0, 0, 500 )
		addEventHandler("onMarkerHit", marker, TruckerStart)
	end
end

createMarkers()


function spawnTrailer()
	if getElementType(source) == "player" then 
		local spawnedTruck = getPedOccupiedVehicle( source )
		local spawnedTrailer = getElementData( source, "Trucker.trailer" )
		
		trx,try,trz = getElementRotation(spawnedTruck)
		
		if ( spawnedTrailer ~= false ) then 
			if isElement(spawnedTrailer) then
				destroyElement(spawnedTrailer)
			end
			setElementData(source, "Trucker.trailer", false) 
		end
		
		Trailer = createVehicle (584, 2759.53, -2393.11, 150000, 0, 0, trz) --435, 450, 584, 591 <<These are all acceptable trailer ID's for trucks
		setElementData(source, "Trucker.trailer", Trailer) 
		local spawnedTrailer = getElementData( source, "Trucker.trailer" )
		setTimer(function()attachTrailerToVehicle ( spawnedTruck, spawnedTrailer )end, 100, 1)
		
		if isTrailerDetached == true then
			removeEventHandler("onTrailerAttach", getRootElement(), TrailerAttach)
			isTrailerDetached = false
		end
		
		if Handler == false then
			setTimer(function()addEventHandler("onTrailerDetach", getRootElement(), TrailerDetach)end, 3000, 1)
			Handler = true
		else
			removeEventHandler("onTrailerDetach", root, TrailerDetach)
			setTimer(function()addEventHandler("onTrailerDetach", getRootElement(), TrailerDetach)end, 3000, 1)
		end
		
		setElementData(source, "Trucker.can-be-rewarded", true) 
	end
end
addEvent("createTrailer", true)
addEventHandler("createTrailer", getRootElement(), spawnTrailer)


function giveReward(cash)
	if getElementType(source) == "player" then 
		if not isPedInVehicle ( source ) then 
			outputChatBox("Dude, where's the truck?", source, 255,0,0 )
			return
		else
			if getElementData(source, "Trucker.can-be-rewarded") == true then
				Vehicle = getPedOccupiedVehicle(source)
				if getElementModel ( Vehicle ) == 403 or getElementModel ( Vehicle ) == 514 or getElementModel ( Vehicle ) == 515 then 
					local spawnedTrailer = getElementData( source, "Trucker.trailer" )
					givePlayerMoney(source, cash)
					removeEventHandler("onTrailerDetach", getRootElement(), TrailerDetach)
					removeEventHandler("onTrailerAttach", getRootElement(), TrailerAttach)
					setElementData(source, "Trucker.can-be-rewarded", false)
					destroyElement(spawnedTrailer) 
					spawnedTrailer = nil 
					setElementData(source, "Trucker.trailer", false)
					setElementData (source, "Trucker.pres",(getElementData (source, "Trucker.pres")or 0 ) + 1)
				end
			else
				outputChatBox("It appears you have forgot to bring your trailer... Well! this is a bummer! Go get another trailer.", source, 255,0,0 )
			end
		end
	end	
end
addEvent("truckerReward", true)
addEventHandler("truckerReward", getRootElement(), giveReward)


function TrailerDetach(theTruck)
	thePlayer = getVehicleOccupant ( theTruck, 0 )  
	local spawnedTrailer = getElementData( thePlayer, "Trucker.trailer" )
	if source == spawnedTrailer then 
		setElementData(thePlayer, "Trucker.can-be-rewarded", false)
		removeEventHandler("onTrailerDetach", getRootElement(), TrailerDetach)
		addEventHandler("onTrailerAttach", getRootElement(), TrailerAttach)
		isTrailerDetached = true
		outputChatBox("You must get your trailer!", thePlayer, 100,100,50 )
		setElementData(thePlayer, "Trucker.detached", true) 
	end
end


function TrailerAttach(theTruck)
	thePlayer = getVehicleOccupant ( theTruck, 0 )  
	local spawnedTrailer = getElementData( thePlayer, "Trucker.trailer" )
	if source == spawnedTrailer then 
		setElementData(thePlayer, "Trucker.can-be-rewarded", true)
		addEventHandler("onTrailerDetach", getRootElement(), TrailerDetach)
		removeEventHandler("onTrailerAttach", getRootElement(), TrailerAttach)
		setElementData(thePlayer, "Trucker.detached", false)
	end
end

local TruckTimer
local TrailerTimer

function ExitVehicle(thePlayer)
	if getPlayerTeam(thePlayer) == (TruckerTeam) then
		local spawnedTruck = getElementData( thePlayer, "Trucker.truck" )
		local theTrailer = getElementData( thePlayer, "Trucker.trailer" ) --Name changed from spawnedTrailer to prevent conflict
		if source == spawnedTruck then
			outputChatBox("You have 20 seconds to get back to your truck!", thePlayer)
		end
			TruckTimer = setTimer(function()
					if ( spawnedTruck ~= false ) and ( isElement(spawnedTruck) ) then --(~= is not equal) 
						destroyElement(spawnedTruck)
						setElementData(thePlayer, "Trucker.truck", false)
					end
					if (theTrailer) ~= false and isElement(theTrailer) then
						destroyElement(theTrailer)
						setElementData(thePlayer, "Trucker.trailer", false)
					end
					triggerClientEvent(thePlayer, "destroyMarker", thePlayer)
					triggerClientEvent(thePlayer, "shipmentMarker", thePlayer)
				end,20000,1)
		if not (spawnedTruck) and (theTrailer) then
			outputChatBox("You have 20 seconds to get back to your truck!", thePlayer)
			TrailerTimer = setTimer(function()
				if not isElement(spawnedTruck) and isElement(theTrailer) then
					destroyElement(theTrailer)
					triggerClientEvent(thePlayer, "destroyMarker", thePlayer)
					setElementData(thePlayer, "Trucker.trailer", false)
					triggerClientEvent(thePlayer, "shipmentMarker", thePlayer)
				end
			end,20000,1)
		end
	end
end

addEventHandler("onVehicleExit",getRootElement(),ExitVehicle)

function EnterVehicle(thePlayer)
	if getPlayerTeam(thePlayer) == (TruckerTeam) then
		local spawnedTruck = getElementData( thePlayer, "Trucker.truck" )
		if source == spawnedTruck then
			if isTimer(TruckTimer) then 
				killTimer(TruckTimer)
			end
		end
		if source == spawnedTruck or getElementModel ( source ) == 403 or getElementModel ( source ) == 514 or getElementModel ( source ) == 515 then
			if isTimer(TrailerTimer) then 
				killTimer(TrailerTimer)
			end
		end
	end
end

addEventHandler("onVehicleEnter",getRootElement(),EnterVehicle)

function SaveShipments(quitType, reason, responsibleElement)
	if not (isGuestAccount (getPlayerAccount (source))) then
		local account = getPlayerAccount (source)
		if (account) then
			local PlayerShipments = getElementData( source, "Trucker.pres" )
			if (PlayerShipments) then
				setAccountData (account, "Trucker.pres", PlayerShipments)
			end
		end
	end
end

addEventHandler("onPlayerQuit", getRootElement(), SaveShipments)


function GetShipments(quitType, reason, responsibleElement)
	if not (isGuestAccount (getPlayerAccount (source))) then
		local account = getPlayerAccount (source)
		if (account) then
			local PlayerShipments = getAccountData( account, "Trucker.pres" )
			if (PlayerShipments) then
			setElementData (source, "Trucker.pres", PlayerShipments)
			end
		end
	end
end

addEventHandler("onPlayerLogin", getRootElement(), GetShipments)


--When vehicles explode the players data will be removed
function explodingTruck()
	if timer == true then
		for _,player in ipairs(getElementsByType("player")) do --LOOP through all Vehicles
			local spawnedTruck = getElementData( player, "Trucker.truck" )
			local theTrailer = getElementData( player, "Trucker.trailer" )
			if source == spawnedTruck then 
				setElementData(player, "Trucker.truck", false)
			end
			if source == theTrailer then
				setElementData(player, "Trucker.trailer", false)
				triggerClientEvent(player, "destroyMarker", player)
				triggerClientEvent(player, "shipmentMarker", player)
			end
		end
	end
end
addEventHandler("onVehicleExplode",getRootElement(),explodingTruck)


function tellShipments(thePlayer)
	PlayerShipments = getElementData( thePlayer, "Trucker.pres" )
	if (PlayerShipments) then
		outputChatBox("You have made "..PlayerShipments.." deliveries in total!", thePlayer, 20, 140, 50)
	end
end

addCommandHandler("shipments", tellShipments)


function bbTrucker(thePlayer)
	triggerClientEvent(thePlayer, "destroyTruckerStuff", thePlayer)
end

addCommandHandler("byetwucker", bbTrucker)