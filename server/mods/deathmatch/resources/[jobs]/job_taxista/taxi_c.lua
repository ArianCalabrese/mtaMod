GUITaxista = {
    memo = {},
    button = {},
    label = {},
    window = {},
    panel = {}
}

local bInfos = {{
    vecPos = {1776.8, -1887.1, 12.6},
    sText = "Emprego: Taxista",
    iColor = tocolor(255, 255, 0, 255),
    fDistance = 20,
    fScale = 1.02,
    sFont = "default"
}};

function Render()
    for _, Data in pairs(bInfos) do
        local fPosX, fPosY, fPosZ = getElementPosition(localPlayer);
        local fDataX, fDataY, fDataZ = unpack(Data.vecPos);
        local fDistanceBetweenPoints = getDistanceBetweenPoints3D(fPosX, fPosY, fPosZ, fDataX, fDataY, fDataZ);
        local fInputDistance = Data.fDistance or 20;
        if fDistanceBetweenPoints < fInputDistance then
            local fCameraX, fCameraY, fCameraZ = getCameraMatrix();
            local fWorldPosX, fWorldPosY = getScreenFromWorldPosition(fDataX, fDataY, fDataZ + 1, fInputDistance);
            local bHit = processLineOfSight(fCameraX, fCameraY, fCameraZ, fDataX, fDataY, fDataZ, true, false, false,
                             true, false, false, false, false);
            if not bHit then
                if fWorldPosX and fWorldPosY then
                    dxDrawText(Data.sText, fWorldPosX, fWorldPosY, fWorldPosX, fWorldPosY, Data.iColor, Data.fScale,
                        Data.sFont);
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, Render);

addEventHandler("onClientResourceStart", resourceRoot, function()
    local x, y = guiGetScreenSize()
    GUITaxista.window[1] = guiCreateWindow(x / 2 - 250, y / 2 - 110, 500, 220, "EMPREGO DE TAXISTA", false)
    guiWindowSetSizable(GUITaxista.window[1], false)
    guiWindowSetMovable(GUITaxista.window[1], false)
    guiSetVisible(GUITaxista.window[1], false)

    GUITaxista.memo[1] = guiCreateMemo(10, 20, 480, 150,
                             "Torne-se um Taxista e obtenha bons salários por cada corrida! Para começar, apenas entre em um Taxi, digite /taxion e dirija até o blip de alvo vermelho no mapa e pegue o passageiro. Então deixe o passageiro no ponto marcado no mapa. Moleza demais! Você ainda pode ser promovido e ganhar salários melhores se trabalhar bastante.\nVocê também pode usar /taximetro 1, 2 ou 3 para começar a cobrar dinheiro do jogador que estiver sentado no banco indicado do seu Taxi.\nObs: Ao ser demitido, deslogar ou sair do servidor, todo seu progresso irá zerar.",
                             false, GUITaxista.window[1])
    guiMemoSetReadOnly(GUITaxista.memo[1], true)

    GUITaxista.button[1] = guiCreateButton(10, 180, 120, 30, "Aceitar Emprego", false, GUITaxista.window[1])
    guiSetProperty(GUITaxista.button[1], "NormalTextColour", "FFFFFF00")
    addEventHandler("onClientGUIClick", GUITaxista.button[1], showGUIbf, false)
    addEventHandler("onClientGUIClick", GUITaxista.button[1], joinTeam, false)

    GUITaxista.button[2] = guiCreateButton(420, 180, 70, 30, "Cancelar", false, GUITaxista.window[1])
    guiSetProperty(GUITaxista.button[2], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", GUITaxista.button[2], showGUIbf, false)

    GUITaxista.label1 = guiCreateLabel(213, 195, 30, 20, "By: ", false, GUITaxista.window[1])
    GUITaxista.label2 = guiCreateLabel(233, 195, 120, 20, "LordHenry", false, GUITaxista.window[1])
    guiLabelSetColor(GUITaxista.label1, 0, 255, 0)
    guiLabelSetColor(GUITaxista.label2, 0, 100, 250)
end)

local joinBD = createMarker(1777.05078125, -1886.853515625, 12.387156486511, "cylinder", 0.9, 255, 255, 0)
blipTaxi = createBlipAttachedTo(joinBD, 60, 2, 255, 0, 0, 255, 1, 500)

function showGUIbt(hitElement)
    if not (isPedInVehicle(hitElement)) then
        if getElementType(hitElement) == "player" and (hitElement == localPlayer) then
            guiSetVisible(GUITaxista.window[1], true)
            showCursor(true)
        end
    end
end
addEventHandler("onClientMarkerHit", joinBD, showGUIbt)

function showGUIbf()
    guiSetVisible(GUITaxista.window[1], false)
    showCursor(false)
end

function joinTeam()
    triggerServerEvent("sTeame", localPlayer, "teamSet")
end

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    for oX = -3, 3 do -- Border size is 3
        for oY = -3, 3 do -- Border size is 3
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX,
                alignY, clip, wordBreak, postGUI)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

local tempo = {}
function playMusic()
    local sound = playSound("Mission Accomplished.mp3")
    local screenX, screenY = guiGetScreenSize()
    tempo[localPlayer] = 0
    function maxTaxista()
        dxDrawBorderedText("taxista concluído!", 1, 1, screenX, screenY - 75, tocolor(150, 100, 0, 255), 3,
            "pricedown", "center", "center", true, false)
        dxDrawBorderedText("$1000000", 1, 75, screenX, screenY, tocolor(255, 255, 255, 255), 3, "pricedown", "center",
            "center", true, false)
    end
    addEventHandler("onClientRender", getRootElement(), maxTaxista)
    setTimer(function()
        tempo[localPlayer] = tempo[localPlayer] + 1
        if tempo[localPlayer] == 5 then
            removeEventHandler("onClientRender", getRootElement(), maxTaxista)
        end
    end, 1000, 5)
end
addEvent("winTaxi", true)
addEventHandler("winTaxi", getRootElement(), playMusic)
-- addCommandHandler ("venceu", playMusic)
