function animations(command, animation)
    if not animation then
        return outputChatBox("SYNTAX:/" .. command .. " [animacion]. Use /" .. command ..
                                 " para ver todas las animaciones")
    end
    if animation == "stop" then
        setPedAnimation(root)
    end
    if animation == "list" then
        -- "/handsup, /dance, /rap, /wank, /strip, /sexy, /bj, /cell, /lean, /piss, /robman\n"
        -- "/greet, /injured, /hitch, /bitchslap, /cpr, /gsign, /gift, /getup, /follow\n"
        -- "/sit, /stand, /slapped, /slapass, /drunk, /gwalk, /walk, /celebrate, /win /checkout\n"
        -- "/yes, /deal, /thankyou, /invite1, /scratch, /bomb, /getarrested, /laugh \n"
        -- "/crossarms, /lay, /cover, /vomit, /eat, /wave, /crack, /smoke,  /lookout\n"
        -- "/chat, /fucku, /taichi, /chairsit, /relax, /bat /nod, /cry /chant, /carsmoke, /aim\n"
        -- "/gang1, /bed, /carsit, /stretch, /angry, /kiss, /exhausted, /ghand, /benddown\n"
        -- "/basket, /akick, /box, /cockgun, /bar, /lay, /liftup, /putdown, /die, /joint\n"
        return outputChatBox("sentarse")
    end
    if animation == "sentarse" then
        setPedAnimation(root, "ped", "seat_down", -1, false, false, true, true)
    end
end

addCommandHandler('e', animations, false, false)
