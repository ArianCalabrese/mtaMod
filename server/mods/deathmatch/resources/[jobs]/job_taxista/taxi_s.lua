loop = {}

function theLoop()
    local players = getElementsByType("player")
    for k, v in ipairs(players) do
        loop[v] = true
    end
end
addEventHandler("onResourceStart", getResourceRootElement(), theLoop)

function StopAll()
    destroyElement(leaveBD)
    local players = getElementsByType("player")
    for k, v in ipairs(players) do
        if getElementData(v, "Job") == "Taxista" then
            removeElementData(v, "Job")
            removeElementData(v, "Job.cargo")
            removeElementData(v, "Job.level")
            removeElementData(v, "Job.exp")
            removeElementData(v, "Job.nextExp")
            removeElementData(v, "working")
            loop[v] = true
        end
        if getElementData(v, "pagando.Taxi1") then
            removeElementData(v, "pagando.Taxi1")
        end
        if getElementData(v, "pagando.Taxi2") then
            removeElementData(v, "pagando.Taxi2")
        end
        if getElementData(v, "pagando.Taxi3") then
            removeElementData(v, "pagando.Taxi3")
        end
    end
end
addEventHandler("onResourceStop", getResourceRootElement(), StopAll)

local pickups =
    { -- Locais para pegar o passageiro, por padrão só tem local em LS. Se você quer fazer testes com apenas lugares mais próximos, torne todos os locais como comentários exceto o primeiro. Você tem total liberdade de criar mais lugares, inclusive fora de LS.
        [1] = {2060.7685546875, -1941.1181640625, 13.14103603363}, -- [int]={x,y,z},
        [2] = {2086.9731445313, -1571.7086181641, 13.38231754303},
        [3] = {1922.9521484375, -1758.1259765625, 13.16081237793},
        [4] = {1032.1564941406, -1552.7036132813, 13.545647621155},
        [5] = {1133.2607421875, -1286.6201171875, 13.245727539063},
        [6] = {1162.1402587891, -1717.9711914063, 13.945343971252},
        [7] = {1249.0665283203, -2049.9089355469, 59.945289611816},
        [8] = {825.31280517578, -1870.5678710938, 12.8671875},
        [9] = {405.81915283203, -1778.1610107422, 5.5676455497742},
        [10] = {438.53366088867, -1559.4774169922, 27.096113204956},
        [11] = {364.37173461914, -2032.6544189453, 7.8359375},
        [12] = {1538.4653320313, -1668.3834228516, 13.546875},
        [13] = {2337.2072753906, -1755.1708984375, 13.546875},
        [14] = {2743.7092285156, -1399.5821533203, 36.014904022217},
        [15] = {2084.12890625, -989.28393554688, 51.387241363525},
        [16] = {480.31030273438, -1083.2176513672, 82.36449432373},
        [17] = {1993.064453125, -1444.3308105469, 13.566058158875},
        [18] = {1693.7320556641, -2118.39453125, 13.546875},
        [19] = {1730.1832275391, -2325.1818847656, -2.6796875},
        [20] = {1522.5122070313, -840.650390625, 66.837211608887}
    }

local dropoffss =
    { -- Locais para deixar o passageiro, mesma coisa do de cima, também só tem em LS por padrão. Se quiser só testar, deixe todos como comentário exceto o primeiro. Prefira deixar somente em LS pois distâncias muito grandes acabam dando grana demais e assim fica fácil demais ficar rico.
        [1] = {1836.6943359375, -1853.4180908203, 13.389747619629}, -- [int]={x,y,z},
        [2] = {820.87921142578, -1331.5625, 13.399520874023},
        [3] = {1480.8833007813, -1736.3049316406, 13.3828125},
        [4] = {1663.5258789063, -2249.857421875, 13.36238861084},
        [5] = {1316.4953613281, -1711.0581054688, 13.3828125},
        [6] = {1535.8258056641, -1675.1617431641, 13.3828125},
        [7] = {1462.1573486328, -1029.87890625, 23.65625},
        [8] = {958.70483398438, -1103.4434814453, 23.693437576294},
        [9] = {641.75445556641, -1354.9268798828, 13.393319129944},
        [10] = {669.14666748047, -1286.0563964844, 13.4609375},
        [11] = {373.52780151367, -2028.4714355469, 7.671875},
        [12] = {337.38031005859, -1809.3972167969, 4.5101089477539},
        [13] = {2222.396484375, -1099.4151611328, 27.968030929565},
        [14] = {2266.8337402344, -1339.8352050781, 23.828125},
        [15] = {2507.9228515625, -1671.7788085938, 13.378329277039},
        [16] = {2784.4025878906, -1834.5792236328, 9.8110237121582},
        [17] = {2687.8728027344, -2457.0334472656, 13.491540908813},
        [18] = {1742.9429931641, -1858.8715820313, 13.4140625},
        [19] = {1244.7414550781, -2037.1936035156, 59.86262512207},
        [20] = {1128.9367675781, -1409.6903076172, 13.453979492188}
    }

local pedCus =
    { -- Skins dos passageiros aleatórios, cada um com a ID da skin. Não use skins de policiais nem qualquer skin com restrição. Você pode adicionar mais skins, quantas quiser.
        [1] = {9}, -- [int]={ID},
        [2] = {10},
        [3] = {14},
        [4] = {15},
        [5] = {37},
        [6] = {7},
        [7] = {9},
        [8] = {12},
        [9] = {13},
        [10] = {20},
        [11] = {21},
        [12] = {22},
        [13] = {23},
        [14] = {28},
        [15] = {29},
        [16] = {30},
        [17] = {35},
        [18] = {40},
        [19] = {41},
        [20] = {60}
    }

if not getTeamFromName("Taxistas") then -- Se não existe um time "Taxistas" criado, faz o seguinte:
    Teame = createTeam("Taxistas", 255, 255, 0) -- Cria o time de Taxistas.
else -- Se já existe um time de "Taxistas" criado, faz o seguinte:
    Teame = getTeamFromName("Taxistas") -- Teame recebe o time dos Taxistas.
end
taxiVeh = {}
taxiTeams = {
    [Teame] = true
}
leaveBD = createMarker(1753.2, -1894.15, 12.7, "cylinder", 0.9, 255, 0, 0) -- Cria um mark vermelho próximo ao mark amarelo, serve para se demitir do emprego.

function teamSet()
    local account = getPlayerAccount(source)
    if isGuestAccount(account) then
        outputChatBox("Você não pode trabalhar deslogado.", source, 255, 50, 0)
        return
    end
    if not getElementData(source, "Job") then -- Se o jogador não tiver profissão, faz o seguinte:
        setPlayerTeam(source, Teame) -- Coloca o jogador no 'Teame'.
        setPlayerNametagColor(source, 255, 255, 0) -- Coloca o nome do jogador em amarelo, pelo menos onde ele não estiver com cor.
        setElementModel(source, 253) -- Coloca a skin 253 no jogador.
        setElementData(source, "Job", "Taxista")
        setElementData(source, "Job.cargo", "Ajudante de Carregador de bagagem")
        setElementData(source, "Job.level", 1)
        setElementData(source, "Job.exp", 0)
        setElementData(source, "Job.nextExp", 2000)
        accountname = getAccountName(getPlayerAccount(source))
        if isObjectInACLGroup("user." .. accountname, aclGetGroup(get("vipACL"))) then -- Se o jogador estiver na ACL Vip, faz o seguinte:
            taxiVeh[source] = createVehicle(438, 1777.3017578125, -1891.779296875, 13.157614707947) -- Cria um Cabbie, taxi de luxo (ID 438) na coordenada especificada.
            outputChatBox("Jogadores VIP podem trabalhar com este Taxi de Luxo.", source)
        else -- Se o jogador não for vip, faz o seguinte:
            taxiVeh[source] = createVehicle(420, 1777.3017578125, -1891.779296875, 13.157614707947) -- Cria um taxi (ID 420) na coordenada especificada.
        end
        outputChatBox("Você agora tem um emprego de Taxista!", source)
    elseif getElementData(source, "Job") == "Taxista" then -- Se o jogador for Taxista, faz o seguinte:
        cancelEvent()
        outputChatBox("Você já é Taxista!", source)
    else
        cancelEvent()
        outputChatBox("Erro: Você precisa se demitir de sua atual profissão primeiro. (" ..
                          getElementData(source, "Job") .. ")", source, 255, 100, 0)
    end
end
addEvent("sTeame", true)
addEventHandler("sTeame", root, teamSet)

function teamLeave(hitElement)
    if hitElement and getElementType(hitElement) == "player" then
        if not getPedOccupiedVehicle(hitElement) then
            if getElementData(hitElement, "Job") then -- Se o jogador tiver um emprego, faz o seguinte:
                outputChatBox("Você foi demitido do emprego de " .. getElementData(hitElement, "Job"), hitElement)
                destroyJob(hitElement)
                setPlayerTeam(hitElement, nil) -- Remove o jogador do 'Teame', deixando-o sem time.
                setPlayerNametagColor(hitElement, false) -- Remove a cor do nome do jogador, pelo menos onde ele não estiver com cor.
                removeElementData(hitElement, "Job") -- Remove a profissão de Taxista.
                removeElementData(hitElement, "Job.cargo") -- Remove o cargo de Taxista.
                removeElementData(hitElement, "Job.level") -- Zera o level de profissão.
                removeElementData(hitElement, "Job.exp") -- Zera o Exp de profissão.
                removeElementData(hitElement, "Job.nextExp") -- Zera o Exp necessário para ser promovido.
                removeElementData(hitElement, "working") -- O jogador não está mais trabalhando.
                if taxiVeh[hitElement] and isElement(taxiVeh[hitElement]) then
                    destroyElement(taxiVeh[hitElement])
                    taxiVeh[hitElement] = nil
                end
                if isElement(peds[hitElement]) then
                    destroyElement(peds[hitElement])
                    peds[hitElement] = nil
                end
            else -- Se o jogador não for Taxista, faz o seguinte:
                outputChatBox("Erro: Você precisa ter um emprego compatível para se demitir aqui.", hitElement, 255,
                    50, 0)
            end
        end
    end
end
addEventHandler("onMarkerHit", leaveBD, teamLeave)

function teamLeave(prevAcc, _)
    if getElementData(source, "Job") == "Taxista" then -- Se o jogador for Taxista, faz o seguinte:
        destroyJob(source)
        setPlayerTeam(source, nil) -- Remove o jogador do 'Teame', deixando-o sem time.
        setPlayerNametagColor(source, false) -- Remove a cor do nome do jogador, pelo menos onde ele não estiver com cor.
        removeElementData(source, "Job") -- Remove a profissão de Taxista.
        removeElementData(source, "Job.cargo") -- Remove o cargo de Taxista.
        removeElementData(source, "Job.level") -- Zera o level de profissão.
        removeElementData(source, "Job.exp") -- Zera o Exp de profissão.
        removeElementData(source, "Job.nextExp") -- Zera o Exp necessário para ser promovido.
        removeElementData(source, "working") -- O jogador não está mais trabalhando.
        outputChatBox("Você foi demitido do emprego de Taxista.", source)
        if isElement(taxiVeh[source]) then
            destroyElement(taxiVeh[source])
            taxiVeh[source] = nil
        end
        if isElement(peds[source]) then
            destroyElement(peds[source])
            peds[source] = nil
        end
    end
end
addEventHandler("onPlayerLogout", getRootElement(), teamLeave)

function teamQuit(quitType, reason, responsible)
    if getElementData(source, "Job") == "Taxista" then
        destroyJob(source)
        if isElement(taxiVeh[source]) then
            destroyElement(taxiVeh[source])
            taxiVeh[source] = nil
        end
        if isElement(peds[source]) then
            destroyElement(peds[source])
            peds[source] = nil
        end
    end
end
addEventHandler("onPlayerQuit", getRootElement(), teamQuit)

function lightTaxiOn(thePlayer) -- Mostra uma mensagem ao jogador com os requisitos abaixo. (antes era pra ligar a luz do taxi, mas ela já liga ao iniciar o serviço)
    if isPedInVehicle(thePlayer) then -- Se o jogador estiver em um veículo, faz o seguinte:
        local vehicle = getPedOccupiedVehicle(thePlayer) -- Variável local "vehicle" recebe os dados do veículo que o jogador estiver ocupando.
        if getVehicleController(vehicle) == thePlayer then -- Se o jogador for o motorista do veículo, faz o seguinte:
            local id = getElementModel(vehicle) -- Variável local "id" recebe o ID da variável "vehicle".
            if (id == 420) or (id == 438) then -- Se o ID for 420 ou 438 (IDs dos taxis), faz o seguinte:
                if getElementData(thePlayer, "Job") == "Taxista" then
                    if not (getElementData(thePlayer, "working")) then
                        outputChatBox("Você iniciou o serviço de taxista.", thePlayer)
                        setElementData(thePlayer, "working", "taxi")
                    end
                else
                    outputChatBox("Erro: Você não pode trabalhar com este veículo sem ser um Taxista.", thePlayer,
                        255, 100, 0)
                end
            end
        end
    end
end
addCommandHandler("taxion", lightTaxiOn) -- Executa essa função ao usar o comando /taxion.

markers = {} -- Variáveis que podem receber mais de um valor ao mesmo tempo. Por exemplo coordenadas.
blips = {}
peds = {}
mposi = {}
mposii = {}

addEventHandler("onPlayerLogin", getRootElement(), function()
    loop[source] = true
end)

function lightTaxiOff(thePlayer) -- Mostra uma mensagem ao jogador que atende os requisitos abaixo. (antes desligava a luz do taxi, mas isso já acontece ao finalizar o serviço.)
    if isPedInVehicle(thePlayer) then
        local vehicle = getPedOccupiedVehicle(thePlayer)
        if getVehicleController(vehicle) == thePlayer then
            local id = getElementModel(vehicle)
            if (id == 420) or (id == 438) then
                if (getElementData(thePlayer, "working") == "taxi") then
                    outputChatBox("Você finalizou o serviço de taxista.", thePlayer)
                    setElementData(thePlayer, "working", false)
                    if (isElement(peds[thePlayer])) then
                        destroyElement(peds[thePlayer]) -- Deleta o NPC.
                        loop[thePlayer] = true
                    end
                end
            end
        end
    end
end
addCommandHandler("taxioff", lightTaxiOff) -- Executa essa função ao usar o comando /taxioff

function lightTaxiOut(thePlayer, seat, jacked)
    if getElementModel(source) == 420 or getElementModel(source) == 438 then
        if seat == 0 then
            if getElementData(thePlayer, "working") == "taxi" then
                outputChatBox("Você finalizou o serviço de taxista.", thePlayer)
                setElementData(thePlayer, "working", false)
                if (isElement(peds[thePlayer])) then
                    destroyElement(peds[thePlayer])
                    loop[thePlayer] = true
                end
            end
        end
    end
end
addEventHandler("onVehicleExit", getRootElement(), lightTaxiOut) -- Executa essa função ao sair de um veículo.

function startJob(thePlayer) -- Inicia o trabalho de taxista, com todos os esquemas de NPCs, checkpoints e tudo mais.
    if loop[thePlayer] == true then -- Evita de criar outro NPC se o jogador usar o comando /taxion depois de já ter um NPC no mapa.
        if isPedInVehicle(thePlayer) then -- Se o jogador estiver em um veículo, faça o seguinte:
            if getElementData(thePlayer, "Job") == "Taxista" then -- Se o jogador for Taxista, faz o seguinte:
                local vehicle = getPedOccupiedVehicle(thePlayer) -- Variável local 'vehicle' recebe os dados do veículo em que o jogador está ocupando.
                if getVehicleController(vehicle) == thePlayer then
                    local id = getElementModel(vehicle) -- Variável local 'id' recebe o ID do elemento 'vehicle'.
                    if (id == 420) or (id == 438) then -- Se o veículo for um taxi, faz o seguinte:
                        local x, y, z = unpack(pickups[math.random(#pickups)]) -- Variaveis x,y,z recebem valores da coordenada de um pickup aleatório.
                        markers[thePlayer] = createMarker(x, y, z, "cylinder", 5.0, 255, 0, 0, 0) -- Cria um cilindro vermelho de raio 5 na posição x,y,z.
                        setElementData(markers[thePlayer], "owner", thePlayer)
                        mposi = {getElementPosition(markers[thePlayer])} -- Recebe a posição do elemento "markers".
                        local skins = unpack(pedCus[math.random(#pedCus)]) -- Variável local skins recebe um valor de pedcus aleatório.
                        peds[thePlayer] = createPed(skins, x, y, z) -- Cria um NPC com a 'skin' na posição 'x,y,z'.
                        setElementData(peds[thePlayer], "owner", thePlayer)
                        outputChatBox("Há um cliente esperando, siga o ícone de alvo vermelho no GPS e busque-o.",
                            thePlayer)
                        blips[thePlayer] = createBlipAttachedTo(markers[thePlayer], 41, 2, 255, 0, 0, 255, 50, 99999,
                                               thePlayer) -- Cria um blip no gps com posição anexada ao cilindro.
                        addEventHandler("onMarkerHit", markers[thePlayer], warpit) -- Executa a função warpit quando o jogador encostar no cilindro.
                        local vehicle = getPedOccupiedVehicle(thePlayer) -- Variável local 'vehicle' recebe dados do veículo que o jogador estiver ocupando.
                        setVehicleTaxiLightOn(vehicle, true) -- Liga a luz de taxi do veículo do jogador.
                        loop[thePlayer] = false
                        local level = getElementData(thePlayer, "Job.level")
                        if getElementData(thePlayer, "Job.exp") >= getElementData(thePlayer, "Job.nextExp") then
                            level = (getElementData(thePlayer, "Job.level") + 1)
                            setElementData(thePlayer, "Job.level", level)
                            outputChatBox(
                                "O seu nível de taxista agora é: " .. getElementData(thePlayer, "Job.level") .. ".",
                                thePlayer, 0, 255, 0, true)
                            if getElementData(thePlayer, "Job.level") == 1 then
                                setElementData(thePlayer, "Job.nextExp", 2000) -- 2000
                                setElementData(thePlayer, "Job.cargo", "Ajudante de Carregador de bagagem")
                                setElementData(thePlayer, "Job.nextCargo", "Carregador de bagagem")
                                playSoundFrontEnd(thePlayer, 43)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 2 then
                                setElementData(thePlayer, "Job.nextExp", 5000) -- 5000
                                setElementData(thePlayer, "Job.cargo", "Carregador de bagagem")
                                setElementData(thePlayer, "Job.nextCargo", "Manobrista de Ponto de Taxi")
                                playSoundFrontEnd(thePlayer, 43)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 3 then
                                setElementData(thePlayer, "Job.nextExp", 10000) -- 10000
                                setElementData(thePlayer, "Job.cargo", "Manobrista de Ponto de Taxi")
                                setElementData(thePlayer, "Job.nextCargo", "Taxista Amador")
                                addVehicleUpgrade(vehicle, 1087)
                                outputChatBox("Seu taxi agora possui #909090Hydraulics.", thePlayer, 255, 255, 0, true)
                                playSoundFrontEnd(thePlayer, 46)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 4 then
                                setElementData(thePlayer, "Job.nextExp", 15000) -- 20000
                                setElementData(thePlayer, "Job.cargo", "Taxista Amador")
                                setElementData(thePlayer, "Job.nextCargo", "Taxista Local")
                                playSoundFrontEnd(thePlayer, 43)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 5 then
                                setElementData(thePlayer, "Job.nextExp", 20000) -- 30000
                                setElementData(thePlayer, "Job.cargo", "Taxista Local")
                                setElementData(thePlayer, "Job.nextCargo", "Taxista Profissional")
                                addVehicleUpgrade(vehicle, 1010)
                                playSoundFrontEnd(thePlayer, 46)
                                outputChatBox("Seu taxi agora possui #00AAFFNitro.", thePlayer, 255, 255, 0, true)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 6 then
                                setElementData(thePlayer, "Job.nextExp", 30000) -- 40000
                                setElementData(thePlayer, "Job.cargo", "Taxista Profissional")
                                setElementData(thePlayer, "Job.nextCargo", "Taxista Internacional")
                                playSoundFrontEnd(thePlayer, 43)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 7 then
                                setElementData(thePlayer, "Job.nextExp", 40000) -- 70000
                                setElementData(thePlayer, "Job.cargo", "Taxista Internacional")
                                setElementData(thePlayer, "Job.nextCargo", "Locador de Taxis")
                                playSoundFrontEnd(thePlayer, 43)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 8 then
                                setElementData(thePlayer, "Job.nextExp", 60000) -- 100000
                                setElementData(thePlayer, "Job.cargo", "Locador de Taxis")
                                setElementData(thePlayer, "Job.nextCargo", "Gerente da Empresa de Taxis")
                                playSoundFrontEnd(thePlayer, 16)
                                setVehicleColor(vehicle, 0, 0, 0)
                                outputChatBox("Seu taxi agora é #FFFFFFExecutivo.", thePlayer, 255, 255, 0, true)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 9 then
                                setElementData(thePlayer, "Job.nextExp", 80000) -- 150000
                                setElementData(thePlayer, "Job.cargo", "Gerente da Empresa de Taxis")
                                setElementData(thePlayer, "Job.nextCargo", "Presidente da Empresa de Taxis")
                                playSoundFrontEnd(thePlayer, 43)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            elseif getElementData(thePlayer, "Job.level") == 10 then
                                setElementData(thePlayer, "Job.nextExp", 999999999) -- 999999999
                                setElementData(thePlayer, "Job.cargo", "Presidente da Empresa de Taxis")
                                setElementData(thePlayer, "Job.nextCargo", "Nenhum")
                                outputChatBox("Nível máximo de taxista atingido!", thePlayer, 0, 255, 0)
                                triggerClientEvent(thePlayer, "winTaxi", getRootElement())
                                givePlayerMoney(thePlayer, 1000000)
                                if get("repairTaxi") == true then
                                    fixVehicle(vehicle)
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        outputChatBox("Você já está trabalhando nisso.", thePlayer, 255, 50, 50)
    end
end
addCommandHandler("taxion", startJob) -- Executa essa função ao usar o comando /taxion

function warpit(thePlayer) -- Teleporta o NPC para o veículo e coloca o novo destino no gps.
    if (getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer)) then -- Se for um jogador e ele estiver em um veículo, faz o seguinte:
        local vehiclee = getPedOccupiedVehicle(thePlayer) -- variável local 'vehiclee' recebe os dados do veículo do jogador.
        if (getElementModel(vehiclee) == 420) or (getElementModel(vehiclee) == 438) then -- Se o veículo for um taxi, faz o seguinte:
            if isElement(peds[thePlayer]) then
                if getElementHealth(vehiclee) >= 300 then
                    local clientes = getVehicleOccupants(vehiclee)
                    if getElementData(peds[thePlayer], "owner") ~= thePlayer then
                        outputChatBox("Este cliente não é seu.", thePlayer, 255, 50, 0)
                        return
                    end
                    if not clientes[3] then
                        warpPedIntoVehicle(peds[thePlayer], vehiclee, 3)
                    elseif not clientes[2] then
                        warpPedIntoVehicle(peds[thePlayer], vehiclee, 2)
                    elseif not clientes[1] then
                        warpPedIntoVehicle(peds[thePlayer], vehiclee, 1)
                    else
                        outputChatBox("Erro: Não tem nenhum lugar disponível no seu Taxi para o passageiro sentar.",
                            thePlayer, 255, 150, 0)
                        return
                    end
                    destroyJob(thePlayer)
                    local x, y, z = unpack(dropoffss[math.random(#dropoffss)])
                    markers[thePlayer] = createMarker(x, y, z - 1, "cylinder", 5.0, 255, 0, 0, 50, thePlayer)
                    setElementData(markers[thePlayer], "owner", thePlayer)
                    mposii = {getElementPosition(markers[thePlayer])}
                    blips[thePlayer] = createBlipAttachedTo(markers[thePlayer], 41, 2, 255, 0, 0, 255, 50, 99999,
                                           thePlayer)
                    addEventHandler("onMarkerHit", markers[thePlayer], pickmeup)
                    if (x == 1836.6943359375) and (y == -1853.4180908203) and (z == 13.389747619629) then -- Se a coordenada de destino for a especificada, faz o seguinte:
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF008 Ball Autopeças#FFFF00.", thePlayer,
                            255, 255, 0, true) -- Mensagem em amarelo do Cliente dizendo onde quer ir, informando o nome do lugar em verde.
                    elseif (x == 820.87921142578) and (y == -1331.5625) and (z == 13.399520874023) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Estação Market#FFFF00.", thePlayer, 255,
                            255, 0, true)
                    elseif (x == 1480.8833007813) and (y == -1736.3049316406) and (z == 13.3828125) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Prefeitura de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 1663.5258789063) and (y == -2249.857421875) and (z == 13.36238861084) then
                        outputChatBox(
                            "Cliente: Olá, desejo ir até o #00FF00Aeroporto Internacional de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 1316.4953613281) and (y == -1711.0581054688) and (z == 13.3828125) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Cinema de Los Santos#FFFF00.", thePlayer,
                            255, 255, 0, true)
                    elseif (x == 1535.8258056641) and (y == -1675.1617431641) and (z == 13.3828125) then
                        outputChatBox(
                            "Cliente: Olá, desejo ir até o #00FF00Departamento de Polícia de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 1462.1573486328) and (y == -1029.87890625) and (z == 23.65625) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Banco Central de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 958.70483398438) and (y == -1103.4434814453) and (z == 23.693437576294) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Cemitério de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 641.75445556641) and (y == -1354.9268798828) and (z == 13.393319129944) then
                        outputChatBox(
                            "Cliente: Olá, desejo ir até a #00FF00Interglobal Estúdios de Televisão#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 669.14666748047) and (y == -1286.0563964844) and (z == 13.4609375) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Clube de Tênis de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 373.52780151367) and (y == -2028.4714355469) and (z == 7.671875) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Roda Gigante#FFFF00.", thePlayer, 255,
                            255, 0, true)
                    elseif (x == 337.38031005859) and (y == -1809.3972167969) and (z == 4.5101089477539) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Praia de Santa Maria#FFFF00.", thePlayer,
                            255, 255, 0, true)
                    elseif (x == 2222.396484375) and (y == -1099.4151611328) and (z == 27.968030929565) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Favela#FFFF00.", thePlayer, 255, 255, 0,
                            true)
                    elseif (x == 2266.8337402344) and (y == -1339.8352050781) and (z == 23.828125) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Igreja de Los Santos#FFFF00.", thePlayer,
                            255, 255, 0, true)
                    elseif (x == 2507.9228515625) and (y == -1671.7788085938) and (z == 13.378329277039) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Grove Street#FFFF00.", thePlayer, 255,
                            255, 0, true)
                    elseif (x == 2784.4025878906) and (y == -1834.5792236328) and (z == 9.8110237121582) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Estádio de Derby de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 2687.8728027344) and (y == -2457.0334472656) and (z == 13.491540908813) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Porto de Los Santos#FFFF00.", thePlayer,
                            255, 255, 0, true)
                    elseif (x == 1742.9429931641) and (y == -1858.8715820313) and (z == 13.4140625) then
                        outputChatBox("Cliente: Olá, desejo ir até a #00FF00Estação Unity#FFFF00.", thePlayer, 255,
                            255, 0, true)
                    elseif (x == 1244.7414550781) and (y == -2037.1936035156) and (z == 59.86262512207) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Observatório de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    elseif (x == 1128.9367675781) and (y == -1409.6903076172) and (z == 13.453979492188) then
                        outputChatBox("Cliente: Olá, desejo ir até o #00FF00Shopping de Los Santos#FFFF00.",
                            thePlayer, 255, 255, 0, true)
                    else
                        outputChatBox("Cliente: Oi, não sei onde quero ir.", thePlayer, 255, 255, 0, true) -- Se isso ocorrer, tem algo errado com o script. Você alterou algo errado.
                    end
                else
                    outputChatBox("Cliente: Esse Taxi está quase pegando fogo! Eu não vou entrar nisso!", thePlayer,
                        255, 255, 0, true)
                end
            end
        end
    end
end

function pickmeup(hitElement)
    if getElementType(hitElement) == "player" and isPedInVehicle(hitElement) then
        local vehicle = getPedOccupiedVehicle(hitElement)
        if (getElementModel(vehicle) == 420) or (getElementModel(vehicle) == 438) then
            if getElementData(hitElement, "Job") == "Taxista" then
                if getElementData(source, "owner") == hitElement then
                    destroyJob(hitElement)
                    local mx, my, mz = unpack(mposi)
                    local mmx, mmy, mmz = unpack(mposii)
                    local money = getDistanceBetweenPoints2D(mx, my, mmx, mmy)
                    local experience = (getElementData(hitElement, "Job.exp") + math.floor(money))
                    setElementData(hitElement, "Job.exp", experience)

                    finalmoney = math.floor(getElementData(hitElement, "Job.level") * money)
                    outputChatBox("Cliente: Obrigado, aqui está o dinheiro.", hitElement, 255, 255, 0, true)
                    if finalmoney then
                        setTimer(givePlayerMoney, 2000, 1, hitElement, finalmoney)
                        setTimer(outputChatBox, 2000, 1, "Distância: " .. math.floor(money) .. " metros.", hitElement)
                        setTimer(outputChatBox, 2000, 1, "Você recebeu $" .. finalmoney .. "!", hitElement, 231, 217,
                            176, true)
                        setTimer(function()
                            if isElement(peds[hitElement]) then
                                destroyElement(peds[hitElement])
                            end
                            loop[hitElement] = true
                            startJob(hitElement)
                        end, 2000, 1)
                    end
                end
            end
        end
    end
end

function destroyJob(thePlayer)
    if isElement(markers[thePlayer]) then
        destroyElement(markers[thePlayer]) -- Destroi os cilindros no mapa.
    end
    if isElement(blips[thePlayer]) then
        destroyElement(blips[thePlayer]) -- Destroi os blips do gps.
    end
    if getPedOccupiedVehicle(thePlayer) then
        local vehicle = getPedOccupiedVehicle(thePlayer)
        if getElementModel(vehicle) == 420 or getElementModel(vehicle) == 438 then
            if getVehicleController(vehicle) == thePlayer then
                setVehicleTaxiLightOn(vehicle, false) -- Desliga a luz do taxi.
            end
        end
    end
end
addCommandHandler("taxioff", destroyJob) -- Executa essa função ao usar o comando /taxioff

function detonaJob(thePlayer, seat, jacked)
    if isElement(markers[thePlayer]) then
        destroyElement(markers[thePlayer])
    end
    if isElement(blips[thePlayer]) then
        destroyElement(blips[thePlayer])
    end
    if getElementModel(source) == 420 or getElementModel(source) == 438 then
        if seat == 0 then
            setVehicleTaxiLightOn(source, false)
        end
    end
end
addEventHandler("onVehicleExit", getRootElement(), detonaJob) -- Executa essa função ao começar a sair de um veículo.

function killJob(ammo, attacker, weapon, bodypart)
    setTimer(destroyJob, 2000, 1, source)
    if taxiVeh[source] then
        destroyElement(taxiVeh[source])
        taxiVeh[source] = nil
    end
    if (getElementData(source, "working") == "taxi") then
        outputChatBox("Você finalizou o serviço de taxista.", source)
        setElementData(source, "working", false)
        if (isElement(peds[source])) then
            destroyElement(peds[source]) -- Deleta o NPC.
            loop[source] = true
        end
    end
end
addEventHandler("onPlayerWasted", getRootElement(), killJob) -- Executa essa função quando o jogador morre.

cliente1 = {}
cliente2 = {}
cliente3 = {}
tempo1 = {}
tempo2 = {}
tempo3 = {}

function pagaTaximetro(thePlayer, theCliente)
    if getElementData(thePlayer, "Job") == "Taxista" then
        if isPedInVehicle(thePlayer) then
            local vehicle = getPedOccupiedVehicle(thePlayer)
            if (getElementModel(vehicle) == 420) or (getElementModel(vehicle) == 438) then
                if getVehicleController(vehicle) == thePlayer then
                    local tarifa = tonumber(getElementData(thePlayer, "Job.level")) * 50
                    if isElement(theCliente) and getPedOccupiedVehicle(theCliente) == vehicle then
                        if getPlayerMoney(theCliente) >= tarifa then
                            -- outputChatBox ("O cliente pagou $"..tostring (tarifa), thePlayer)
                            takePlayerMoney(theCliente, tarifa)
                            givePlayerMoney(thePlayer, tarifa)
                        else
                            if getElementData(theCliente, "pagando.Taxi1") then
                                removeElementData(theCliente, "pagando.Taxi1")
                                killTimer(tempo1[theCliente])
                                removePedFromVehicle(theCliente)
                                outputChatBox("O cliente do banco 1 não tem dinheiro suficiente para pagar a tarifa.",
                                    thePlayer)
                                outputChatBox(
                                    "Taximetro desativado por falta de dinheiro, agora você não está sendo cobrado.",
                                    theCliente, 0, 255, 0, true)
                            elseif getElementData(theCliente, "pagando.Taxi2") then
                                removeElementData(theCliente, "pagando.Taxi2")
                                killTimer(tempo2[theCliente])
                                removePedFromVehicle(theCliente)
                                outputChatBox("O cliente do banco 2 não tem dinheiro suficiente para pagar a tarifa.",
                                    thePlayer)
                                outputChatBox(
                                    "Taximetro desativado por falta de dinheiro, agora você não está sendo cobrado.",
                                    theCliente, 0, 255, 0, true)
                            elseif getElementData(theCliente, "pagando.Taxi3") then
                                removeElementData(theCliente, "pagando.Taxi3")
                                killTimer(tempo3[theCliente])
                                removePedFromVehicle(theCliente)
                                outputChatBox("O cliente do banco 3 não tem dinheiro suficiente para pagar a tarifa.",
                                    thePlayer)
                                outputChatBox(
                                    "Taximetro desativado por falta de dinheiro, agora você não está sendo cobrado.",
                                    theCliente, 0, 255, 0, true)
                            end
                        end
                    else
                        if isTimer(tempo1[theCliente]) then
                            killTimer(tempo1[theCliente])
                            outputChatBox("O cliente do banco 1 não foi encontrado e portanto parou de ser cobrado.",
                                thePlayer)
                        elseif isTimer(tempo2[theCliente]) then
                            killTimer(tempo2[theCliente])
                            outputChatBox("O cliente do banco 2 não foi encontrado e portanto parou de ser cobrado.",
                                thePlayer)
                        elseif isTimer(tempo3[theCliente]) then
                            killTimer(tempo3[theCliente])
                            outputChatBox("O cliente do banco 3 não foi encontrado e portanto parou de ser cobrado.",
                                thePlayer)
                        end
                    end
                end
            end
        else
            if getElementData(theCliente, "pagando.Taxi1") then
                killTimer(tempo1[theCliente])
                removeElementData(theCliente, "pagando.Taxi1")
                outputChatBox(
                    "O cliente do banco 1 parou de pagar a tarifa pois o Taxista não está mais no veículo.",
                    thePlayer)
                outputChatBox("Taximetro desativado, agora você não está sendo cobrado.", theCliente, 0, 255, 0, true)
            elseif getElementData(theCliente, "pagando.Taxi2") then
                killTimer(tempo2[theCliente])
                removeElementData(theCliente, "pagando.Taxi2")
                outputChatBox(
                    "O cliente do banco 2 parou de pagar a tarifa pois o Taxista não está mais no veículo.",
                    thePlayer)
                outputChatBox("Taximetro desativado, agora você não está sendo cobrado.", theCliente, 0, 255, 0, true)
            elseif getElementData(theCliente, "pagando.Taxi3") then
                killTimer(tempo3[theCliente])
                removeElementData(theCliente, "pagando.Taxi3")
                outputChatBox(
                    "O cliente do banco 3 parou de pagar a tarifa pois o Taxista não está mais no veículo.",
                    thePlayer)
                outputChatBox("Taximetro desativado, agora você não está sendo cobrado.", theCliente, 0, 255, 0, true)
            end
        end
    end
end

addCommandHandler("taximetro", function(thePlayer, cmd, clientSeat)
    if getElementData(thePlayer, "Job") == "Taxista" then
        if isPedInVehicle(thePlayer) then
            local vehicle = getPedOccupiedVehicle(thePlayer)
            if (getElementModel(vehicle) == 420) or (getElementModel(vehicle) == 438) then
                if clientSeat then
                    if getVehicleController(vehicle) == thePlayer then
                        local clientes = getVehicleOccupants(vehicle)
                        if clientSeat == "0" then
                            outputChatBox("Erro: Você não pode cobrar a corrida de quem está dirigindo.", thePlayer,
                                255, 150, 0, true)
                        elseif clientSeat == "1" then
                            cliente1[thePlayer] = clientes[1]
                            if cliente1[thePlayer] and getElementType(cliente1[thePlayer]) == "player" then
                                local nome1 = getPlayerName(cliente1[thePlayer])
                                if not getElementData(cliente1[thePlayer], "pagando.Taxi1") then
                                    outputChatBox("O cliente sentado no banco 1 (" .. nome1 ..
                                                      "#00FF00) começou a pagar a viagem.", thePlayer, 0, 255, 0, true)
                                    outputChatBox("Taximetro ativado, agora você está sendo cobrado.",
                                        cliente1[thePlayer], 255, 255, 0, true)
                                    if not isTimer(tempo1[cliente1[thePlayer]]) then
                                        tempo1[cliente1[thePlayer]] =
                                            setTimer(pagaTaximetro, 5000, 0, thePlayer, cliente1[thePlayer])
                                        setElementData(cliente1[thePlayer], "pagando.Taxi1", true)
                                    end
                                else
                                    if isTimer(tempo1[cliente1[thePlayer]]) then
                                        outputChatBox("O cliente sentado no banco 1 (" .. nome1 ..
                                                          "#FFFF00) parou de pagar a viagem.", thePlayer, 255, 255, 0,
                                            true)
                                        outputChatBox("Taximetro desativado, agora você não será mais cobrado.",
                                            cliente1[thePlayer], 0, 255, 0, true)
                                        removeElementData(cliente1[thePlayer], "pagando.Taxi1")
                                        killTimer(tempo1[cliente1[thePlayer]])
                                    end
                                end
                            else
                                outputChatBox("Erro: Não há nenhum jogador sentado no banco 1 do Taxi.", thePlayer,
                                    255, 150, 0, true)
                            end
                        elseif clientSeat == "2" then
                            cliente2[thePlayer] = clientes[2]
                            if cliente2[thePlayer] and getElementType(cliente2[thePlayer]) == "player" then
                                local nome2 = getPlayerName(cliente2[thePlayer])
                                if not getElementData(cliente2[thePlayer], "pagando.Taxi2") then
                                    outputChatBox("O cliente sentado no banco 2 (" .. nome2 ..
                                                      "#00FF00) começou a pagar a viagem.", thePlayer, 0, 255, 0, true)
                                    outputChatBox("Taximetro ativado, agora você está sendo cobrado.",
                                        cliente2[thePlayer], 255, 255, 0, true)
                                    if not isTimer(tempo2[cliente2[thePlayer]]) then
                                        tempo2[cliente2[thePlayer]] =
                                            setTimer(pagaTaximetro, 5000, 0, thePlayer, cliente2[thePlayer])
                                        setElementData(cliente2[thePlayer], "pagando.Taxi2", true)
                                    end
                                else
                                    if isTimer(tempo2[cliente2[thePlayer]]) then
                                        outputChatBox("O cliente sentado no banco 2 (" .. nome2 ..
                                                          "#FFFF00) parou de pagar a viagem.", thePlayer, 255, 255, 0,
                                            true)
                                        outputChatBox("Taximetro desativado, agora você não será mais cobrado.",
                                            cliente2[thePlayer], 0, 255, 0, true)
                                        removeElementData(cliente2[thePlayer], "pagando.Taxi2")
                                        killTimer(tempo2[cliente2[thePlayer]])
                                    end
                                end
                            else
                                outputChatBox("Erro: Não há nenhum jogador sentado no banco 2 do Taxi.", thePlayer,
                                    255, 150, 0, true)
                            end
                        elseif clientSeat == "3" then
                            cliente3[thePlayer] = clientes[3]
                            if cliente3[thePlayer] and getElementType(cliente3[thePlayer]) == "player" then
                                local nome3 = getPlayerName(cliente3[thePlayer])
                                if not getElementData(cliente3[thePlayer], "pagando.Taxi3") then
                                    outputChatBox("O cliente sentado no banco 3 (" .. nome3 ..
                                                      "#00FF00) começou a pagar a viagem.", thePlayer, 0, 255, 0, true)
                                    outputChatBox("Taximetro ativado, agora você está sendo cobrado.",
                                        cliente3[thePlayer], 255, 255, 0, true)
                                    if not isTimer(tempo3[cliente3[thePlayer]]) then
                                        tempo3[cliente3[thePlayer]] =
                                            setTimer(pagaTaximetro, 5000, 0, thePlayer, cliente3[thePlayer])
                                        setElementData(cliente3[thePlayer], "pagando.Taxi3", true)
                                    end
                                else
                                    if isTimer(tempo3[cliente3[thePlayer]]) then
                                        outputChatBox("O cliente sentado no banco 3 (" .. nome3 ..
                                                          "#FFFF00) parou de pagar a viagem.", thePlayer, 255, 255, 0,
                                            true)
                                        outputChatBox("Taximetro desativado, agora você não será mais cobrado.",
                                            cliente3[thePlayer], 0, 255, 0, true)
                                        removeElementData(cliente3[thePlayer], "pagando.Taxi3")
                                        killTimer(tempo3[cliente3[thePlayer]])
                                    end
                                end
                            else
                                outputChatBox("Erro: Não há nenhum jogador sentado no banco 3 do Taxi.", thePlayer,
                                    255, 150, 0, true)
                            end
                        else
                            outputChatBox("Erro: Não existe o banco " .. clientSeat .. ".", thePlayer, 255, 150, 0,
                                true)
                        end
                    else
                        outputChatBox("Erro: Somente o motorista do Taxi pode mexer no taximetro.", thePlayer, 255, 150,
                            0, true)
                    end
                else
                    outputChatBox("Sintaxe: /taximetro <1~3>", thePlayer, 255, 150, 0, true)
                end
            end
        end
    end
end)

addCommandHandler("reset", function(theStaff, cmd, theResource)
    if hasObjectPermissionTo(theStaff, "function.setResourceDefaultSetting", false) then
        if theResource == "job-taxista" then
            local metaXML = xmlLoadFile("meta.xml")
            local settings = xmlFindChild(metaXML, "settings", 0)
            local setting01 = xmlFindChild(settings, "setting", 0)
            local setting02 = xmlFindChild(settings, "setting", 1)

            local valor = xmlNodeGetAttribute(setting01, "value")
            valor = string.gsub(valor, "%p", "")
            if valor == "true" then
                valor = true
            elseif valor == "false" then
                valor = false
            end
            set("*repairTaxi", valor)

            local valor = xmlNodeGetAttribute(setting02, "value")
            valor = string.gsub(valor, "%p", "")
            set("*vipACL", valor)

            outputChatBox("As configurações do resource '" .. theResource .. "' foram restauradas ao valor padrão.",
                theStaff)
        end
    else
        outputChatBox("Você não tem acesso a este comando.", theStaff, 255, 50, 50)
    end
end)
