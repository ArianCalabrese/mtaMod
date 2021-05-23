--local jobBlip = createBlip(-2160.69482, 578.58685, 35.17188,10)
local jobBlip = createBlip(2103.73, -1824.77, 13, 10)
local jobVehicle={448, 2098, -1825.7, 13.5};
local amount = math.random(9,12)
addEvent("warpPedIntoVehicle",true)
addEventHandler("warpPedIntoVehicle",resourceRoot,function()
  if getElementData(client,"start:job") == false then return end
  local vehJob = createVehicle(jobVehicle[1],jobVehicle[2],jobVehicle[3],jobVehicle[4])
  warpPedIntoVehicle(client,vehJob,0)
end)

addEvent("TakeMoneyCare",true)
addEventHandler("TakeMoneyCare",resourceRoot,function()
  if getElementData(client,"start:job") == true then return end
  givePlayerMoney(source,amount)
end)
