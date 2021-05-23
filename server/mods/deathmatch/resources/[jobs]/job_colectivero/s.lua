trab2 = createMarker ( 1449.7485351563,-2287.5083007813,12.546875 , "cylinder", 1.5, 255,140,0, 255)

blip = createBlipAttachedTo(trab2, 56, 3, 255, 0, 0, 255, 0, 65535)

entregartrab2 = createMarker ( 1627.8881835938,-2321.9890136719,13.3828125 , "checkpoint", 5, 255,140,0, 255)
setElementVisibleTo ( entregartrab2, root, false )

entregarparte2 = createMarker ( -2249.4982910156,2327.0158691406,4.8125 , "checkpoint", 3, 255,140,0, 255)
setElementVisibleTo ( entregarparte2, root, false )

bliptparte2 = createBlipAttachedTo(entregarparte2, 53, 3, 255, 0, 0, 255, 0, 65535, source)
setElementVisibleTo ( bliptparte2, root, false )

bliptrab2 = createBlipAttachedTo(entregartrab2, 53, 3, 255, 0, 0, 255, 0, 65535, source)
setElementVisibleTo ( bliptrab2, root, false )

function msg (source)
outputChatBox ('#000000[#FF3030Trabajo #000000] #FFFFFFUse #FF0000/aceptar #FFFFFFPara Tarbajar de Colectivero',source,255,255,255,true)
end
addEventHandler( "onMarkerHit", trab2, msg )


veh = {}
function pegartrab ( source )
if isElementWithinMarker (source, trab2 ) then
if veh[source] and isElement( veh[source] ) then destroyElement(veh[source] )
 veh[source] = nil
 end
 local x,y,z = getElementPosition(source)
 veh[source] = createVehicle(431 ,1550.1964111328,-2236.6333007813,13.546875)
 warpPedIntoVehicle (source,veh[source])
setPedSkin ( source, 72 )
setElementVisibleTo ( bliptrab2, source, true )
setElementVisibleTo ( entregartrab2, source, true )
ped1 = createPed ( 1, 1626.453125,-2325.5517578125,13.546875 )
setPedRotation(ped1, 50)
ped2 = createPed ( 7, 1628.3549804688,-2325.4658203125,13.546875 )
setPedRotation(ped2, 50)
ped3 = createPed ( 15, 1630.2360839844,-2325.7419433594,13.546875 )
setPedRotation(ped3, 50)
ped4 = createPed ( 16, 1629.5208740234,-2327.2788085938,13.546875 )
setPedRotation(ped4, 50)
ped5 = createPed ( 17, 1627.7957763672,-2327.4816894531,13.546875 )
setPedRotation(ped5, 50)
ped6 = createPed ( 17, 1626.5053710938,-2328.6127929688,13.546875 )
setPedRotation(ped6, 50)
outputChatBox ('#000000[#FF3030Trabajo #000000] #00BFFFUn grupo de empresarios perdieron su avión y los llevaron al helipuerto privado en sf',source,255,255,255,true)
outputChatBox ('#000000[#FF3030Trabajo #000000] #00BFFFAhora elija pasajeros, vaya a la bandera del mapa #FF3030F11',source,255,255,255,true)
else
outputChatBox ('#000000[#FF3030Trabajo #000000] #FF0000Tienes que estar en el trabajo del cofer de Bus para escribir este comando',source,255,255,255,true)
end
end
addCommandHandler ( "aceptar", pegartrab  )

function parte2 (source)
if veh[source] and isElement(veh[source]) then
setElementVisibleTo ( entregartrab2, source, false )
setElementVisibleTo ( bliptrab2, source, false )
outputChatBox ('#000000[#FF3030Trabajo #000000] #00BFFFEspera a que entren para continuar.',source,255,255,255,true)
setPedAnimation( ped1, "ped", "WOMAN_walknorm")
setPedAnimation( ped2, "ped", "WOMAN_walknorm")
setPedAnimation( ped3, "ped", "WOMAN_walknorm")
setPedAnimation( ped4, "ped", "WOMAN_walknorm")
setPedAnimation( ped5, "ped", "WOMAN_walknorm")
setPedAnimation( ped6, "ped", "WOMAN_walknorm")
setTimer ( function()
destroyElement (ped1)
destroyElement (ped2)
destroyElement (ped3)
destroyElement (ped4)
destroyElement (ped5)
destroyElement (ped6)
setElementVisibleTo ( bliptparte2, source, true )
setElementVisibleTo ( entregarparte2, source, true )
outputChatBox ('#000000[#FF3030Trabajo #000000] #00BFFFLlevar pasajeros a helipuerto en sf #FF3030>>> #00BFFF en la bandera de mapa #FF0000F11<<',source,255,255,255,true)
	end, 3000, 1 )
else
end
end
addEventHandler( "onMarkerHit", entregartrab2, parte2 )

function finalizar (source)
if veh[source] and isElement(veh[source]) then
setElementVisibleTo ( bliptparte2, source, false )
setElementVisibleTo ( entregarparte2, source, false )
givePlayerMoney (source, 8000)
setPedSkin (source,0)
destroyElement (veh[source])
outputChatBox ('#000000[#FF3030Trabajo #000000] #00BFFFTrabajo terminado has recibido #00FF008,000$$',source,255,255,255,true)
else
end
end
addEventHandler( "onMarkerHit", entregarparte2, finalizar )

function sair (source)
if (veh[source]) and isElement(veh[source]) then
Trabalho = false
destroyElement (veh[source])
destroyElement (ped1)
destroyElement (ped2)
destroyElement (ped3)
setElementVisibleTo ( entregartrab2, source, false )
setElementVisibleTo ( bliptrab2, source, false )
setElementVisibleTo ( entregarparte2, source, false )
setElementVisibleTo ( bliptparte2, source, false )
setPedSkin (source,0)
outputChatBox ('#000000[#FF3030Trabajo #000000] #FF0000Dejaste el vehículo y perdiste tu trabajo',source,255,255,255,true)
setElementData(source, "Trab", false)
   end
end
addEventHandler ("onVehicleExit", root, sair)