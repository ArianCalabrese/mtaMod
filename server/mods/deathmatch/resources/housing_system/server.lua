enterMarkerType = "corona" -- Default ( corona )
enterMarkerSize = 0.5 -- Default ( 0.5 )
enterMarkerColor = 255, 100, 255 -- Default ( 255,100,255 )
housesCanBuy = 2 -- You can chose 1 or 2, if u but 3,4,5... or 0 then script wont gonna work, dont tell i havent warn you. Default ( 1 )

gResRoot = getResourceRootElement(getThisResource())
function loadAllHouses ()
  local root = xmlLoadFile ("homes.xml")
  local houseroot = xmlFindChild (root,"houses",0)
  if (houseroot) then
    allHouses = {}
    for i,v in ipairs (xmlNodeGetChildren(houseroot)) do
      local x = xmlNodeGetAttribute (v,"x")
      local y = xmlNodeGetAttribute (v,"y")
      local z = xmlNodeGetAttribute (v,"z")
	  local lx = xmlNodeGetAttribute (v,"lx")
      local ly = xmlNodeGetAttribute (v,"ly")
      local lz = xmlNodeGetAttribute (v,"lz")
      local number = xmlNodeGetAttribute (v,"num")
      if not (xmlNodeGetAttribute (v,"owner") == "") then
        local marker = createMarker (tonumber(x),tonumber(y),tonumber(z),"corona",0.8,255,0,0,0)
        setElementData (marker,"housenumber",tonumber(number))
		local marker2 = createMarker (tonumber(lx),tonumber(ly),tonumber(lz),enterMarkerType,enterMarkerSize,enterMarkerColor,255)
        setElementData (marker2,"housenumber2",tonumber(number))
		pickup = createPickup (tonumber(x),tonumber(y),tonumber(z),3,1272,0)
		setElementData ( pickup, "housenumber", number )
      else
		local marker2 = createMarker (tonumber(lx),tonumber(ly),tonumber(lz),enterMarkerType,enterMarkerSize,enterMarkerColor,255)
        setElementData (marker2,"housenumber2",tonumber(number))
        local marker = createMarker (tonumber(x),tonumber(y),tonumber(z),"corona",0.8,0,255,0,0)
        setElementData (marker,"housenumber",tonumber(number))
		pickup = createPickup (tonumber(x),tonumber(y),tonumber(z),3,1273,0)
		setElementData ( pickup, "housenumber", number )
      end
    --  outputDebugString ("House " .. tostring(number) .. " loaded!")
    end
  end
end
addEventHandler("onResourceStart",gResRoot, loadAllHouses)

addEventHandler ("onMarkerHit",getRootElement(),
function(hitElement, dimension)
  if (getElementType (hitElement) == "player") and not (isPedInVehicle (hitElement)) then
    if (getElementData (source,"housenumber")) then
      local housenumber = getElementData (source,"housenumber")
      --outputChatBox (tostring(housenumber),hitElement,255,0,0,false)
      local root = xmlLoadFile ("homes.xml")
      local houseHeadRootNode = xmlFindChild (root,"houses",0)
      local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))
      if (tostring(xmlNodeGetAttribute (houseRootNode,"owner")) == "") then
        triggerClientEvent (hitElement,"viewHouseGUIwindow",hitElement,"For Sell!",tostring(xmlNodeGetAttribute (houseRootNode,"cost")),housenumber,tostring(xmlNodeGetAttribute (houseRootNode,"sellprice")),tostring(xmlNodeGetAttribute (houseRootNode,"street")))
        xmlUnloadFile (root)
      else
        triggerClientEvent (hitElement,"viewHouseGUIwindow",hitElement,tostring(xmlNodeGetAttribute (houseRootNode,"owner")),tostring(xmlNodeGetAttribute (houseRootNode,"cost")),housenumber,tostring(xmlNodeGetAttribute (houseRootNode,"sellprice")),tostring(xmlNodeGetAttribute (houseRootNode,"street")))
        xmlUnloadFile (root)
      end
    end
  end
end)

addEventHandler ("onMarkerHit",getRootElement(),
function(hitElement, dimension)
  if (getElementType (hitElement) == "player") and not (isPedInVehicle (hitElement)) then
    if (getElementData (source,"housenumber2")) then
      local housenumber = getElementData (source,"housenumber2")
      --outputChatBox (tostring(housenumber),hitElement,255,0,0,false)
        triggerEvent ("HouseSystemEnterHouse",hitElement,housenumber)
        xmlUnloadFile (root)
    end
  end
end)

addEvent("HouseSystemEnterHouse",true)
addEvent("HouseSystemBuyHouse",true)
addEvent("HouseSystemSellHouse",true)
addEvent("tryInterior",true)
addEvent("createhome",true)


addEventHandler ("HouseSystemBuyHouse", getRootElement(),
function(housenumber)
  if ( housesCanBuy == 1 ) then
  local root = xmlLoadFile ("homes.xml")
  local houseHeadRootNode = xmlFindChild (root,"houses",0)
  local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))  
  local price = xmlNodeGetAttribute (houseRootNode,"cost")
  local owner = xmlNodeGetAttribute (houseRootNode,"owner")
  local sellPrice = xmlNodeGetAttribute (houseRootNode,"sellprice")
  local street = xmlNodeGetAttribute (houseRootNode,"street")
  local x,y,z = getElementPosition ( source )
  if not (isGuestAccount (getPlayerAccount(source))) then
    if (owner == "") and (getPlayerMoney (source) >= tonumber(price)) then
	local playeraccount = getPlayerAccount ( source )
		if ( playeraccount ) then
			local house = getAccountData ( playeraccount, "house" )
			if (house ~= "yes" ) then
			setAccountData ( playeraccount, "house", "yes" )
			setAccountData ( playeraccount, "price", price )
			setAccountData ( playeraccount, "number", housenumber )
			setAccountData ( playeraccount, "sell", sellPrice )
			setAccountData ( playeraccount, "street", street )
			setAccountData ( playeraccount, "housex", x )
			setAccountData ( playeraccount, "housey", y )
			setAccountData ( playeraccount, "housez", z )
			takePlayerMoney (source,tonumber(price))
			xmlNodeSetAttribute (houseRootNode,"owner",getAccountName(getPlayerAccount(source)))
			outputChatBox ("Congratulations, you are the new owner!",source,255,200,0,false)
			outputChatBox ("Price: ".. tostring(price) .. "$!",source,255,200,0,false)
			for i,v in ipairs ( getElementsByType("pickup")) do
			local number = getElementData ( v, "housenumber" )
			if ( number == housenumber ) then
			setPickupType ( v, 3, 1272 )
			end
			end
			xmlSaveFile (root)
			else
			outputChatBox ("You have house already!",source,255,0,0,false)
			end
		elseif not (owner == "") then
			outputChatBox ("Sorry, This house is already bought!",source,255,0,0,false)
		elseif (getPlayerMoney (source) < tonumber(price)) then
			outputChatBox ("Sorry, you are too poor!",source,255,0,0,false)
			end
		else
			outputChatBox ("You are too poor or house is bought!",source,255,0,0,false)
			end
		end
	xmlUnloadFile (root) 

	
	elseif ( housesCanBuy == 2 ) then
	local root = xmlLoadFile ("homes.xml")
    local houseHeadRootNode = xmlFindChild (root,"houses",0)
    local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))  
    local price = xmlNodeGetAttribute (houseRootNode,"cost")
    local owner = xmlNodeGetAttribute (houseRootNode,"owner")
    local sellPrice = xmlNodeGetAttribute (houseRootNode,"sellprice")
    local street = xmlNodeGetAttribute (houseRootNode,"street")
    local x,y,z = getElementPosition ( source )
    if not (isGuestAccount (getPlayerAccount(source))) then
	 if (owner == "") and (getPlayerMoney (source) >= tonumber(price)) then
	local playeraccount = getPlayerAccount ( source )
		if ( playeraccount ) then
			local house = getAccountData ( playeraccount, "house" )
			if (house ~= "yes" ) then
			setAccountData ( playeraccount, "house", "yes" )
			setAccountData ( playeraccount, "price", price )
			setAccountData ( playeraccount, "number", housenumber )
			setAccountData ( playeraccount, "sell", sellPrice )
			setAccountData ( playeraccount, "street", street )
			setAccountData ( playeraccount, "housex", x )
			setAccountData ( playeraccount, "housey", y )
			setAccountData ( playeraccount, "housez", z )
			takePlayerMoney (source,tonumber(price))
			xmlNodeSetAttribute (houseRootNode,"owner",getAccountName(getPlayerAccount(source)))
			outputChatBox ("Congratulations, you are the new owner!",source,255,200,0,false)
			outputChatBox ("Price: ".. tostring(price) .. "$!",source,255,200,0,false)
			for i,v in ipairs ( getElementsByType("pickup")) do
			local number = getElementData ( v, "housenumber" )
			if ( number == housenumber ) then
			setPickupType ( v, 3, 1272 )
			end
			end
			xmlSaveFile (root)
			else
			local house2 = getAccountData ( playeraccount, "house2" )
			if (house2 ~= "yes" ) then
			setAccountData ( playeraccount, "house2", "yes" )
			setAccountData ( playeraccount, "price2", price )
			setAccountData ( playeraccount, "number2", housenumber )
			setAccountData ( playeraccount, "sell2", sellPrice )
			setAccountData ( playeraccount, "street2", street )
			setAccountData ( playeraccount, "housex2", x )
			setAccountData ( playeraccount, "housey2", y )
			setAccountData ( playeraccount, "housez2", z )
			takePlayerMoney (source,tonumber(price))
			xmlNodeSetAttribute (houseRootNode,"owner",getAccountName(getPlayerAccount(source)))
			outputChatBox ("Congratulations, you are the new owner!",source,255,200,0,false)
			outputChatBox ("Price: ".. tostring(price) .. "$!",source,255,200,0,false)
			for i,v in ipairs ( getElementsByType("pickup")) do
			local number = getElementData ( v, "housenumber" )
			if ( number == housenumber ) then
			setPickupType ( v, 3, 1272 )
			end
			end
			xmlSaveFile (root)
			else
			outputChatBox ( "You cant buy more than 2 houses!", source, 255,0,0 )
			end
			end
		elseif not (owner == "") then
			outputChatBox ("Sorry, This house is already bought!",source,255,0,0,false)
		elseif (getPlayerMoney (source) < tonumber(price)) then
			outputChatBox ("Sorry, you are too poor!",source,255,0,0,false)
			end
		else
			outputChatBox ("You are too poor or house is bought!",source,255,0,0,false)
			end
		end
	xmlUnloadFile (root)  
	end
end)

addEventHandler ("HouseSystemSellHouse", getRootElement(),
function(housenumber)
  if ( housesCanBuy == 1 ) then
  root = xmlLoadFile ("homes.xml")
  local houseHeadRootNode = xmlFindChild (root,"houses",0)
  local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))  
  local price = xmlNodeGetAttribute (houseRootNode,"sellprice")
  local owner = xmlNodeGetAttribute (houseRootNode,"owner")
  if not (isGuestAccount (getPlayerAccount(source))) then
    if (owner == getAccountName(getPlayerAccount(source))) then
	local playeraccount = getPlayerAccount ( source )
	setAccountData ( playeraccount, "house", "no" )
	setAccountData ( playeraccount, "price", "---" )
	setAccountData ( playeraccount, "number", "---" )
	setAccountData ( playeraccount, "sell", "---" )
	setAccountData ( playeraccount, "street", "---" )
	setAccountData ( playeraccount, "housex", "---" )
	setAccountData ( playeraccount, "housey", "---" )
	setAccountData ( playeraccount, "housez", "---" )
      givePlayerMoney (source,tonumber(price))
      xmlNodeSetAttribute (houseRootNode,"owner","")
	  xmlNodeSetAttribute (houseRootNode,"lockStatus","unlock")
      outputChatBox ("Congratulations, you have sold the home!",source,255,200,0,false)
      outputChatBox ("Obtain: ".. tostring(price) .. "$!",source,255,200,0,false)  
	  xmlSaveFile (root) 
	  for i,v in ipairs ( getElementsByType("pickup")) do
	  local number = getElementData ( v, "housenumber" )
	  if ( number == housenumber ) then
	  setPickupType ( v, 3, 1273 )
	  end
	  end
    elseif not (owner == getAccountName(getPlayerAccount(source))) then
      outputChatBox ("This isn't your house!",source,255,200,0,false)
    end
  else
    outputChatBox ("Please log in!",source,255,200,0,false)
  end
  xmlSaveFile(root)
 elseif ( housesCanBuy == 2 ) then
  local root = xmlLoadFile ("homes.xml")
  local houseHeadRootNode = xmlFindChild (root,"houses",0)
  local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))  
  local price = xmlNodeGetAttribute (houseRootNode,"sellprice")
  local owner = xmlNodeGetAttribute (houseRootNode,"owner")
  if not (isGuestAccount (getPlayerAccount(source))) then
    if (owner == getAccountName(getPlayerAccount(source))) then
	local playeraccount = getPlayerAccount ( source )
	local house1 = getAccountData ( playeraccount, "house" )
	if ( house1 ) then
	local number = getAccountData ( playeraccount, "number")
	if ( number == housenumber ) then
	setAccountData ( playeraccount, "house", "no" )
	setAccountData ( playeraccount, "price", "---" )
	setAccountData ( playeraccount, "number", "---" )
	setAccountData ( playeraccount, "sell", "---" )
	setAccountData ( playeraccount, "street", "---" )
	setAccountData ( playeraccount, "housex", "---" )
	setAccountData ( playeraccount, "housey", "---" )
	setAccountData ( playeraccount, "housez", "---" )
      givePlayerMoney (source,tonumber(price))
      xmlNodeSetAttribute (houseRootNode,"owner","")
	  xmlNodeSetAttribute (houseRootNode,"lockStatus","unlock")
      outputChatBox ("Congratulations, you have sold the home 1234!",source,255,200,0,false)
      outputChatBox ("Obtain: ".. tostring(price) .. "$!",source,255,200,0,false)  
  xmlSaveFile (root) 
	  for i,v in ipairs ( getElementsByType("pickup")) do
	  local number = getElementData ( v, "housenumber" )
	  if ( number == housenumber ) then
	  setPickupType ( v, 3, 1273 )
	  end
	  end
	  else
	  local house2 = getAccountData ( playeraccount, "house2" )
	if ( house2 ) then
	local number2 = getAccountData ( playeraccount, "number2")
	if ( number2 == housenumber ) then
	setAccountData ( playeraccount, "house2", "no" )
	setAccountData ( playeraccount, "price2", "---" )
	setAccountData ( playeraccount, "number2", "---" )
	setAccountData ( playeraccount, "sell2", "---" )
	setAccountData ( playeraccount, "street2", "---" )
	setAccountData ( playeraccount, "housex2", "---" )
	setAccountData ( playeraccount, "housey2", "---" )
	setAccountData ( playeraccount, "housez2", "---" )
      givePlayerMoney (source,tonumber(price))
      xmlNodeSetAttribute (houseRootNode,"owner","")
	  xmlNodeSetAttribute (houseRootNode,"lockStatus","unlock")
      outputChatBox ("Congratulations, you have sold the home 123!",source,255,200,0,false)
      outputChatBox ("Obtain: ".. tostring(price) .. "$!",source,255,200,0,false)
	xmlSaveFile (root) 
	  for i,v in ipairs ( getElementsByType("pickup")) do
	  local number = getElementData ( v, "housenumber" )
	  if ( number == housenumber ) then
	  setPickupType ( v, 3, 1273 )
	  end
	  end
	  end
	  end
	  end
	  end
    elseif not (owner == getAccountName(getPlayerAccount(source))) then
      outputChatBox ("This isn't your house!",source,255,200,0,false)
    end
  else
    outputChatBox ("Please log in!",source,255,200,0,false)
  end
end  
 xmlUnloadFile (root)  
  xmlSaveFile (root) 
end)

addEventHandler ("HouseSystemEnterHouse",getRootElement(),
function(housenumber)
  local root = xmlLoadFile ("homes.xml")
  local houseHeadRootNode = xmlFindChild (root,"houses",0)
  local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))  
  local x,y,z = getElementPosition (source)
  if ( xmlNodeGetAttribute (houseRootNode,"lockStatus")) then
  if (xmlNodeGetAttribute (houseRootNode,"lockStatus") == "unlock") then
    setElementData (source,"posx",x)
    setElementData (source,"posy",y)
    setElementData (source,"posz",z)
    local interiornumber = xmlNodeGetAttribute (houseRootNode,"interior")
    local interiorRootNode = xmlFindChild (xmlFindChild (root,"interiors",0),"interior",tonumber(interiornumber))  
    setElementInterior (source,tonumber(xmlNodeGetAttribute (interiorRootNode,"id")),tonumber(xmlNodeGetAttribute (interiorRootNode,"x"))+1,tonumber(xmlNodeGetAttribute (interiorRootNode,"y")),tonumber(xmlNodeGetAttribute (interiorRootNode,"z")))
    setElementDimension (source,xmlNodeGetAttribute(houseRootNode,"dim"))
	local leaveMarker = createMarker (tonumber(xmlNodeGetAttribute (interiorRootNode,"x")),tonumber(xmlNodeGetAttribute (interiorRootNode,"y")),tonumber(xmlNodeGetAttribute (interiorRootNode,"z")), "corona", 0.5, 255, 200, 0)
	setElementDimension (leaveMarker,xmlNodeGetAttribute(houseRootNode,"dim"))
	setElementInterior (leaveMarker,tonumber(xmlNodeGetAttribute (interiorRootNode,"id")))
	setElementData ( leaveMarker, "leave","leave")
	else
	outputChatBox ( "The House is locked!", source, 255,200,0 )
  end
  else
  xmlNodeSetAttribute (houseRootNode,"lockStatus", "unlock")
  xmlSaveFile(root)
  end
  xmlUnloadFile (root)
end)

addEventHandler ("onMarkerHit",getRootElement(),
function(hitElement, dimension)
  if (getElementType (hitElement) == "player") and not (isPedInVehicle (hitElement)) then
    if (getElementData (source,"leave")) == "leave" then
      if (getElementData (hitElement,"posx")) and (getElementData (hitElement,"posy")) and (getElementData (hitElement,"posz")) then
    setElementPosition (hitElement,getElementData (hitElement,"posx"),getElementData (hitElement,"posy"),getElementData (hitElement,"posz"))
    setElementInterior (hitElement,0)
    setElementDimension (hitElement,0)
    removeElementData (hitElement,"posx")
    removeElementData (hitElement,"posy")
    removeElementData (hitElement,"posz")
	destroyElement ( source )
	end
    end
  end
end)

addCommandHandler ("leave",
function(thePlayer,command)
  if (getElementInterior (thePlayer) ~= 0) and (getElementData (thePlayer,"posx")) and (getElementData (thePlayer,"posy")) and (getElementData (thePlayer,"posz")) then
    setElementPosition (thePlayer,getElementData (thePlayer,"posx"),getElementData (thePlayer,"posy"),getElementData (thePlayer,"posz"))
    setElementInterior (thePlayer,0)
    setElementDimension (thePlayer,0)
    removeElementData (thePlayer,"posx")
    removeElementData (thePlayer,"posy")
    removeElementData (thePlayer,"posz")
  end
end)

function getHouseCount ()
  local root = xmlLoadFile ("homes.xml")
  local housesRoot = xmlFindChild (root,"houses",0)
  local allHouses = xmlNodeGetChildren (housesRoot)
  houses = 0
  for i,v in ipairs (allHouses) do
    houses = houses+1
  end
  xmlUnloadFile (root)
  return houses
end 

function getMarkerByHousenumber (housenumber)
  for i,v in ipairs (getElementsByType("marker")) do
    if (getElementData (v,"housenumber") == tonumber(housenumber)) then
      return v
    end
  end
end

function gotoHome(thePlayer, commandName)
	  local playeraccount = getPlayerAccount ( thePlayer )
      local housex = getAccountData ( playeraccount, "housex" )
	  local housey = getAccountData ( playeraccount, "housey" )
	  local housez = getAccountData ( playeraccount, "housez" )
	  if ( housex ) and ( housey ) and ( housez ) then
	  setElementPosition ( thePlayer, housex, housey, housez )
	  setElementInterior (thePlayer,0)
    setElementDimension (thePlayer,0)
	  end
end
addCommandHandler ( "home", gotoHome )

function gotoHome2(thePlayer, commandName)
	if ( housesCanBuy == 2 ) then
	  local playeraccount = getPlayerAccount ( thePlayer )
      local housex = getAccountData ( playeraccount, "housex2" )
	  local housey = getAccountData ( playeraccount, "housey2" )
	  local housez = getAccountData ( playeraccount, "housez2" )
	  if ( housex ) and ( housey ) and ( housez ) then
	  setElementPosition ( thePlayer, housex, housey, housez )
	  setElementInterior (thePlayer,0)
    setElementDimension (thePlayer,0)
	  end
	  end
end
addCommandHandler ( "home2", gotoHome2 )
	  
addEventHandler ("tryInterior",getRootElement(),
function(housenumber)
  local root = xmlLoadFile ("homes.xml")
  local houseHeadRootNode = xmlFindChild (root,"interiors",0)
  local houseRootNode = xmlFindChild (houseHeadRootNode,"interior",tonumber(housenumber))  
  if ( getElementInterior(source) == 0 ) then
  local x,y,z = getElementPosition (source)
  setElementData (source,"posx",x)
  setElementData (source,"posy",y)
  setElementData (source,"posz",z)
  end
  setElementInterior (source,tonumber(xmlNodeGetAttribute (houseRootNode,"id")),tonumber(xmlNodeGetAttribute (houseRootNode,"x"))+1,tonumber(xmlNodeGetAttribute (houseRootNode,"y")),tonumber(xmlNodeGetAttribute (houseRootNode,"z")))
  setElementDimension (source,1)
  local leaveMarker = createMarker (tonumber(xmlNodeGetAttribute (houseRootNode,"x")),tonumber(xmlNodeGetAttribute (houseRootNode,"y")),tonumber(xmlNodeGetAttribute (houseRootNode,"z")), "corona", 0.5, 255, 200, 0)
  setElementDimension (leaveMarker,1)
  setElementInterior (leaveMarker,tonumber(xmlNodeGetAttribute (houseRootNode,"id")))
  setElementData ( leaveMarker, "leave","leave")
  xmlUnloadFile (root)
end)

addEventHandler ("createhome", getRootElement(),
function(intNumber, price, sellprice, street, intx, inty, intz, pickupx, pickupy, pickupz)
  if (pickupz) and (not isPedInVehicle(source)) then
    if (hasObjectPermissionTo (source,"command.aexec",false)) then
      local x,y,z = getElementPosition (source)
      local houseCount = tonumber(getHouseCount())
      local root = xmlLoadFile ("homes.xml")
      local housesRoot = xmlFindChild (root,"houses",0)
      local newHouse = xmlCreateChild (housesRoot,"house")
      xmlNodeSetAttribute (newHouse,"dim",houseCount) 
      xmlNodeSetAttribute (newHouse,"interior",intNumber)
      xmlNodeSetAttribute (newHouse,"num",houseCount)
      xmlNodeSetAttribute (newHouse,"x",pickupx)
      xmlNodeSetAttribute (newHouse,"y",pickupy)
      xmlNodeSetAttribute (newHouse,"z",pickupz)
	  xmlNodeSetAttribute (newHouse,"lx",intx)
      xmlNodeSetAttribute (newHouse,"ly",inty)
      xmlNodeSetAttribute (newHouse,"lz",intz)
      xmlNodeSetAttribute (newHouse,"cost",price)
      xmlNodeSetAttribute (newHouse,"owner","")
	  xmlNodeSetAttribute (newHouse,"street",street)
	  xmlNodeSetAttribute (newHouse,"sellprice",sellprice)
	  xmlNodeSetAttribute (newHouse,"lockStatus","unlock")
      outputChatBox ("House System: * Home sucefully created! House Number: "..houseCount,source,255,100,0,false)  
      xmlSaveFile (root)   
      xmlUnloadFile (root)   
	  reloadHomes ()
	  setTimer ( loadAllHouses, 2000, 1 )
    else
      outputChatBox ("Admin only!",source,255,200,0,false)
    end
  else
    outputChatBox ("Fill in all edits, or get out of your vehicle!",thePlayer,255,0,0,false)
  end
end)

function onPlayerLogin ()
	if (hasObjectPermissionTo (source,"command.aexec",false)) then
	bindKey ( source, "F5", "down", showWindow2 )
	end
end
addEventHandler ( "onPlayerLogin", getRootElement(), onPlayerLogin )

function showWindow (thePlayer, commandName )
	if (hasObjectPermissionTo (thePlayer,"command.aexec",false)) then
	triggerClientEvent ( thePlayer, "showWindow", thePlayer )
	end
end
addCommandHandler ( "createhome", showWindow )

function showWindow2 ( thePlayer)
	if (hasObjectPermissionTo (thePlayer,"command.aexec",false)) then
	triggerClientEvent ( thePlayer, "showWindow", thePlayer )
	end
end

function destroyHome ( thePlayer, commandName, houseNumber )
	if (hasObjectPermissionTo (thePlayer,"command.aexec",false)) then
	if ( houseNumber ) then
	local root = xmlLoadFile ("homes.xml")
    local houseroot = xmlFindChild (root,"houses",0)
    if (houseroot) then
    for i,v in ipairs (xmlNodeGetChildren(houseroot)) do
      local xmlnumber = xmlNodeGetAttribute (v,"num")
	  if ( xmlnumber == houseNumber ) then
	  xmlDestroyNode ( v )
	  xmlSaveFile ( root )
	  xmlUnloadFile ( root )
	  reloadHomes ()
	  setTimer ( loadAllHouses, 2000, 1 )
	  break 
	  end
	 end
	 end
	 else
	 outputChatBox ( "House System: * Please add house number too!", thePlayer, 255,100,0 )
	 end
	 end
end
addCommandHandler ( "destroyHouse", destroyHome )

function reloadHomes ()
	for i,v in ipairs ( getElementsByType("marker")) do
	local data = getElementData ( v, "housenumber" ) 
	if ( data ) then
	destroyElement ( v )
	end
	end
	for i,v in ipairs ( getElementsByType ( "pickup")) do
	local data = getElementData ( v, "housenumber" ) 
	if ( data ) then
	destroyElement ( v )
	end
	end
	for i,v in ipairs ( getElementsByType ( "marker")) do
	local data = getElementData ( v, "housenumber2" ) 
	if ( data ) then
	destroyElement ( v )
	end
	end
end


function houseSystemLockHouse(housenumber)
	  local playeraccount = getPlayerAccount ( source )
      local number = getAccountData ( playeraccount, "number" )
	  local number2 = getAccountData ( playeraccount, "number2" )
	  if ( housenumber == number ) or ( housenumber == number2 ) then
	  local root = xmlLoadFile ("homes.xml")
      local houseHeadRootNode = xmlFindChild (root,"houses",0)
      local houseRootNode = xmlFindChild (houseHeadRootNode,"house",tonumber(housenumber))
	  local houseLockStatus = xmlNodeGetAttribute (houseRootNode,"lockStatus")
	  if ( houseLockStatus == "lock" ) then
      xmlNodeSetAttribute (houseRootNode,"lockStatus","unlock")
	  setAccountData ( playeraccount, "houseLocked", "Unlocked" )
	  outputChatBox ("House is unlocked!",source,255,0,0,false)
	  xmlSaveFile (root)   
      xmlUnloadFile (root)
	  else
      xmlNodeSetAttribute (houseRootNode,"lockStatus","lock")
      outputChatBox ("House is locked!",source,255,0,0,false)  
	  setAccountData ( playeraccount, "houseLocked", "Locked" )
      xmlSaveFile (root)   
      xmlUnloadFile (root)   
	  end
	  else
	  outputChatBox ( "This isn't your house!", source, 255, 200, 0 )
	  end
end
addEvent ( "houseSystemLockHouse", true )
addEventHandler ( "houseSystemLockHouse", getRootElement(), houseSystemLockHouse )