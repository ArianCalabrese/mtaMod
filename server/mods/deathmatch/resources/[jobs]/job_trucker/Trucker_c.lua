cargoMarkers = {--Player hits cargoMarker and list is shown, "Locations" table contains the locations on that list.
{2213.8576660156, -2226.1547851563, 12, "Ocean Docks"},
{2747.6467285156, -2410.5747070313, 13.45193195343, "Easter Basin"},
{1613.8598632813, 2330.9729003906, 10.8203125, "Redsands West"},
{-1623.6088867188, 77.336196899414, 3.5546875, "Easter Basin"}
}

local shipmentMarkerVault = {}
local shipmentBlipVault = {}

Locations = {--Here is the table for the locations on cargo list, x, y, z, location (cash is calculated in below function)
{-1351.5205078125, -503.66796875, 14.171875, "SF Airport"},
{2838.658203125, 999.6708984375, 10.75, "Linden Side"},
{2262.89453125, 2792.927734375, 10.8203125, "Spinybed"},
{-576.53063964844, -550.34674072266, 25.529611587524, "Fallen Tree"},
{1414.8941650391, 1088.4053955078, 10.8203125, "LVA Freight Depot"},
{1696.5225830078, 2329.0310058594, 10.8203125, "Redsands West"}
}--Above table is places the player will choose when they hit a "cargoMarker" from the first table, remember to read how the tables are structured.


local Name
local marker
local blip
local cash

function spawnTheTruck(md)
local screenW, screenH = guiGetScreenSize()
    window = guiCreateWindow((screenW - 312) / 2, (screenH - 104) / 2, 312, 104, "Spawn a truck or use your own?", false)
    guiWindowSetSizable(window, false)
	showCursor(true)
	
	label1 = guiCreateLabel(56, 27, 201, 17, "Yes - Spawn a truck.", false, window)
	label2 = guiCreateLabel(56, 40, 201, 17, "No - I brought my own.", false, window)
	guiLabelSetHorizontalAlign ( label1, "center")
	guiLabelSetHorizontalAlign ( label2, "center")
	
    Yes_btn = guiCreateButton(56, 64, 89, 30, "Yes", false, window)
    No_btn = guiCreateButton(168, 65, 89, 29, "No", false, window) 

	marker_data = md
		
	addEventHandler("onClientGUIClick", Yes_btn, spawnYes)
	addEventHandler("onClientGUIClick", No_btn, spawnNo)
end

addEvent("spawnTruck", true)
addEventHandler("spawnTruck", getRootElement(), spawnTheTruck)

function spawnYes(button, state)
	if source == Yes_btn and button == "left" and state == "up" then 
			triggerServerEvent("spawnTruckYes", root, localPlayer, marker_data)
			destroyElement(window)
			showCursor(false)
	end
end

function spawnNo(button, state)
	if source == No_btn and button == "left" and state == "up" then 
		triggerServerEvent("spawnTruckNo", root, localPlayer)
		destroyElement(window)
		showCursor(false)
	end
end

function showGUI()
local screenW, screenH = guiGetScreenSize()
    window = guiCreateWindow((screenW - 498) / 2, (screenH - 266) / 2, 498, 266, "Shipments", false)
    guiWindowSetSizable(window, false)
    gridlist = guiCreateGridList(9, 27, 479, 194, false, window)
    colLocation = guiGridListAddColumn(gridlist, "Location", 0.33)
    colDistance = guiGridListAddColumn(gridlist, "Distance", 0.33)
    colCash = guiGridListAddColumn(gridlist, "Cash", 0.33)
	for i=1,#Locations do --I know this is saying for each line in the table
        local x,y,z,text = Locations[i][1],Locations[i][2],Locations[i][3],Locations[i][4]--x = key 1, y = key 2, z = key 3
		local px,py,pz = getElementPosition(localPlayer)
		local distance = getDistanceBetweenPoints3D(px,py,pz,x,y,z)
		cash = math.floor(distance*3)
		local row = guiGridListAddRow ( gridlist,text, math.floor(distance), cash )
    end
    btn_acc = guiCreateButton(72, 231, 140, 25, "Accept", false, window)
    guiSetFont(btn_acc, "sa-header")
    btn_exit = guiCreateButton(284, 231, 140, 25, "Exit", false, window)
    guiSetFont(btn_exit, "sa-header")    
	showCursor(true)
	
	--Disable Collisions
	local v = getPedOccupiedVehicle(localPlayer) -- Get her's Vehicle ID
	for index,vehicle in ipairs(getElementsByType("vehicle")) do --LOOP through all Vehicles
		setElementCollidableWith(vehicle, v, false) -- Set the Collison off with the Other vehicles.
	end
	
	local playerVehicle = getPedOccupiedVehicle ( localPlayer )
	if (playerVehicle) then
		setElementFrozen ( playerVehicle, true )
	end
	
	addEventHandler("onClientGUIClick", btn_acc, Accept)
	addEventHandler("onClientGUIClick", btn_exit, Exit)
	addEventHandler("onClientDoubleClick", root, DoubleClick)
end

addEvent("TruckerStart", true)
addEventHandler("TruckerStart", getRootElement(), showGUI)


function DoubleClick (button)
    if button == "left" then 
        Name = guiGridListGetItemText(gridlist,guiGridListGetSelectedItem(gridlist),1) --Get the name (Location[4])
        local x, y, z
        for i=1,#Locations do
            if Name == Locations[i][4] then
                x, y, z = Locations[i][1], Locations[i][2], Locations[i][3]
            end
        end
		if isElement (marker) then
			removeEventHandler("onClientMarkerHit", marker, reward)
			destroyElement(marker)
			destroyElement(blip)
		end
        marker = createMarker( x,y,z-1,"cylinder", 3, 0, 100, 0, 100 )
		blip = createBlipAttachedTo(marker, 51 ) --Type, Size, R, G, B
		cash = guiGridListGetItemText(gridlist,guiGridListGetSelectedItem(gridlist),3)
		--outputChatBox(""..cash,255,0,0)
		addEventHandler("onClientMarkerHit", marker, reward)
		
		removeEventHandler("onClientDoubleClick", root, DoubleClick)
		removeEventHandler("onClientGUIClick", btn_acc, DoubleClick)
		destroyElement(window)
		showCursor(false)
		triggerServerEvent("createTrailer", localPlayer)
		
		if #shipmentMarkerVault ~= 0 then
			for index = 1, #shipmentMarkerVault do
				destroyElement(shipmentMarkerVault[index])
				shipmentMarkerVault[index] = nil
			end
		end
		
		if #shipmentBlipVault ~= 0 then
			for index = 1, #shipmentBlipVault do
				destroyElement(shipmentBlipVault[index])
				shipmentBlipVault[index] = nil
			end
		end
		
		local playerVehicle = getPedOccupiedVehicle ( localPlayer )
		if (playerVehicle) then
			setElementFrozen ( playerVehicle, false )
		end
    end
end


function Accept(button, state)
	if source == btn_acc and button == "left" and state == "up" then 
		Name = guiGridListGetItemText(gridlist,guiGridListGetSelectedItem(gridlist),1) --Get the name (Location[4])
        local x, y, z
        for i=1,#Locations do
            if Name == Locations[i][4] then
                x, y, z = Locations[i][1], Locations[i][2], Locations[i][3]
            end
        end
		if isElement (marker) then
			removeEventHandler("onClientMarkerHit", marker, reward)
			destroyElement(marker)
			destroyElement(blip)
		end
        marker = createMarker( x,y,z-1,"cylinder", 3, 0, 100, 0, 100 )
		blip = createBlipAttachedTo(marker, 51 ) --Type, Size, R, G, B
		cash = guiGridListGetItemText(gridlist,guiGridListGetSelectedItem(gridlist),3)
		addEventHandler("onClientMarkerHit", marker, reward)
		
		removeEventHandler("onClientDoubleClick", root, DoubleClick)
		removeEventHandler("onClientGUIClick", btn_acc, DoubleClick)
		destroyElement(window)
		showCursor(false)
		triggerServerEvent("createTrailer", localPlayer)
		
		--destroy markers and clear the table
		if #shipmentMarkerVault ~= 0 then
			for index = 1, #shipmentMarkerVault do
				destroyElement(shipmentMarkerVault[index])
				shipmentMarkerVault[index] = nil
			end
		end
		
		if #shipmentBlipVault ~= 0 then
			for index = 1, #shipmentBlipVault do
				destroyElement(shipmentBlipVault[index])
				shipmentBlipVault[index] = nil
			end
		end
		
		local playerVehicle = getPedOccupiedVehicle ( localPlayer )
		if (playerVehicle) then
			-- set the new freeze status
			setElementFrozen ( playerVehicle, false )
		end
	end
end

function Exit(button, state)
	if source == btn_exit and button == "left" and state == "up" then 
		removeEventHandler("onClientDoubleClick", root, DoubleClick)
		removeEventHandler("onClientGUIClick", btn_acc, DoubleClick)
		removeEventHandler("onClientGUIClick", btn_exit, Exit)
		destroyElement(window)
		showCursor(false)
		
		triggerEvent("shipmentMarker", localPlayer)
		
		local playerVehicle = getPedOccupiedVehicle ( localPlayer )
		if (playerVehicle) then
			setElementFrozen ( playerVehicle, false )
		end
	end
end

function reward()
	for i=1,#Locations do
        if Name == Locations[i][4] then
			destroyElement(marker)
			destroyElement(blip)
			triggerServerEvent("truckerReward", localPlayer, cash)
			triggerEvent ("TruckerStart", localPlayer)
        end
    end
end

function trailerSpawn(hitElement, matchingDimension)
	if isElement(hitElement) and getElementType(hitElement) == "player" and matchingDimension then 
	local checkTeam = getTeamFromName("Trucker") 
		if ( checkTeam ) then 
		local playerTeam = getPlayerTeam(hitElement) 
			if ( playerTeam == checkTeam ) then 
				if not isPedInVehicle ( hitElement ) then 
					outputChatBox("You must be in a truck, get a new one from the job spawn! (yellow blip on map)", 255,0,0 )
					return
				else
					Vehicle = getPedOccupiedVehicle(hitElement)
					if  getElementModel ( Vehicle ) == 403 or getElementModel ( Vehicle ) == 514 or getElementModel ( Vehicle ) == 515 then 
					triggerEvent ("TruckerStart", hitElement)
					end
				end
			end	
		end
	end
end

function destroyMarker()
	if isElement (marker) then
		removeEventHandler("onClientMarkerHit", marker, reward)
		destroyElement(marker)
		destroyElement(blip)
	end
end

addEvent("destroyMarker",true)
addEventHandler("destroyMarker",getRootElement(),destroyMarker)

function makeGoodsMarker()
	if #shipmentMarkerVault ~= 0 then
		for index = 1, #shipmentMarkerVault do
			destroyElement(shipmentMarkerVault[index])
			shipmentMarkerVault[index] = nil
		end
	end
	if #shipmentBlipVault ~= 0 then
		for index = 1, #shipmentBlipVault do
			destroyElement(shipmentBlipVault[index])
			shipmentBlipVault[index] = nil
		end
	end
	for i=1,#cargoMarkers do 
        local x,y,z = cargoMarkers[i][1],cargoMarkers[i][2],cargoMarkers[i][3]--x = key 1, y = key 2, z = key 3		
		GoodsMarker = createMarker( x,y,z-1,"cylinder", 5, 0, 200, 55, 255 )
		TruckerJobBlip = createBlipAttachedTo ( GoodsMarker, 36 )
		shipmentMarkerVault[i] = GoodsMarker
		shipmentBlipVault[i] = TruckerJobBlip
		addEventHandler("onClientMarkerHit", GoodsMarker, trailerSpawn)
	end
end
addEvent("shipmentMarker", true)
addEventHandler("shipmentMarker", getRootElement(), makeGoodsMarker)

function destroyAllMarkersAndBlips()
	if #shipmentMarkerVault ~= 0 then
		for index = 1, #shipmentMarkerVault do
			destroyElement(shipmentMarkerVault[index])
			shipmentMarkerVault[index] = nil
		end
	end
	
	if #shipmentBlipVault ~= 0 then
		for index = 1, #shipmentBlipVault do
			destroyElement(shipmentBlipVault[index])
			shipmentBlipVault[index] = nil
		end
	end
	
	if isElement (marker) then
		removeEventHandler("onClientMarkerHit", marker, reward)
		destroyElement(marker)
		destroyElement(blip)
	end
end
addEvent("destroyTruckerStuff", true)
addEventHandler("destroyTruckerStuff", getRootElement(), destroyAllMarkersAndBlips)