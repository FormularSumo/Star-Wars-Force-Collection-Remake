function pause(pause)
    if pause ~= nil then 
        paused = pause
    else
        paused = not paused
    end
    if songs[0] ~= nil then
        if paused then songs[current_song]:pause() else songs[current_song]:play() end
    end
    gStateMachine:pause()
end

function exitState(partial)
    if not partial then 
        love.audio.stop()
        songs = {}
        background = {}
    elseif partial == 'music' then
        background = {}
    end
    gui = {}
    paused = false
    mouseLocked = false
    yscroll = 0
    rawyscroll = 0
    collectgarbage()
end

function gamespeedSlider(percentage)
    gamespeed = percentage * 4
end

function volumeSlider(percentage)
    love.audio.setVolume(percentage)
    Settings['volume_level'] = percentage
end

function volumeSlider2()
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function switchState(state)
    gStateMachine:change(state[1],state[2],state[3])
end

function loadBattle(table,video)
    P2_deck_cards = table[8]
    if table[2] == 'video' and Settings['videos'] then
        gStateMachine:change('GameState',{table[1], 'video', table[3], table[4], table[5], table[6], table[7]})
    else
        gStateMachine:change('GameState',{table[1], 'photo', 0, table[4], table[5], table[6], table[7]})
    end
end

function exitGame()
    love.event.quit()
end

function repositionMouse(index)
    if gui[index] then
        mouseTouching = gui[index]
    else
        for k, pair in pairs(gui) do
            if pair == index then
                mouseTouching = index
                break
            end
        end
        if mouseTouching ~= index then 
            return
        end
    end

    if mouseTouching.y + mouseTouching.height > VIRTUAL_HEIGHT then
        yscroll = yscroll + (VIRTUAL_HEIGHT - (mouseTouching.y + mouseTouching.height + 50))
        mouseTouching.y = mouseTouching.y + yscroll
    elseif mouseTouching.y < 0 then
        yscroll = yscroll - (mouseTouching.y - 50)
        mouseTouching.y = mouseTouching.y + yscroll
    end
    if mouseTouching.percentage then
        mouseButtonX,mouseButtonY = push.toReal(mouseTouching.x + (mouseTouching.width*mouseTouching.percentage),mouseTouching.y + mouseTouching.height/2)
    else
        mouseButtonX,mouseButtonY = push.toReal(mouseTouching.x+mouseTouching.width/2,mouseTouching.y+mouseTouching.height/2)
    end
    love.mouse.setPosition(mouseButtonX,mouseButtonY)
    love.mouse.setVisible(false)
end

function updateMousePosition()
    mouseLastX,mouseLastY = push.toGame(love.mouse.getPosition())
    if mouseLastX == false or mouseLastY == false then
        mouseLastX = -1
        mouseLastY = -1
        mouseDown = false
    end
end

function testForBackgroundImageLoop(video,seek) --Replays the inputted video if it's finished
    if video:isPlaying() then return end
    video:seek(seek)
    video:play()
end

function calculateQueueLength()
    queue_length = -1
    for k, pair in pairs(songs) do
        queue_length = queue_length + 1
    end
    current_song = 0
    next_song = 1
end

function togglePauseOnLooseFocus()
    Settings['pause_on_loose_focus'] = not Settings['pause_on_loose_focus']
    gui[4]:update_text('Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']))
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function toggleVideos()
    Settings['videos'] = not Settings['videos']
    gui[3]:update_text('Videos: ' .. tostring(Settings['videos']))
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function toggleFPS()
    Settings['FPS_counter'] = not Settings['FPS_counter']
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function controllerBinds(button)
    if button == 'a' then
        return 'return'
    elseif button == 'b' then
        return 'escape'
    elseif button == 'start' then
        return 'space'
    elseif button == 'dpleft' then
        return 'dpleft'
    elseif button == 'dpright' then
        return 'dpright'
    end
    return false
end

function characterStrength(character)
    if character == nil then return 0 end
    if character[1] then
        stats = Characters[character[1]]
        modifier = ((character[2] + (60 - character[2]) / 1.7) / 60) * (1 - ((4 - character[3]) * 0.1))
    else
        stats = Characters[character]
        modifier = 1
    end

    if stats['ranged_offense'] then
        if stats['projectile_count'] then
            offense = ((stats['melee_offense']*modifier)/800)^4/2+(((stats['ranged_offense']*modifier)/800)^4)/2*(1+((stats['range']-1)/20)^0.5/4.5)*stats['projectile_count']
        else
            offense = ((stats['melee_offense']*modifier)/800)^4/2+(((stats['ranged_offense']*modifier)/800)^4)/2*(1+((stats['range']-1)/20)^0.5/4.5)
        end
    else
        offense = ((stats['melee_offense']*modifier)/800)^4*(1+((stats['range']-1)/20)^0.5/9)
    end
    return (offense+((stats['defense']*modifier)/800)^4)*(1+stats['evade']^1/2*2)
end

function compareCharacterStrength(character1, character2)
    return characterStrength(character1) > characterStrength(character2)
end

function tutorial()
    P1_cards = {}
    P1_deck_cards = {}
    bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)

    P1_deck_edit(1,{'Grogu',60,4})
    P1_deck_edit(2,{'Farmboy Luke Skywalker',60,4})
    P1_deck_edit(3,{'C-3PO',60,4})
    P1_deck_edit(4,{'R2-D2',60,4})

    bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
    P1_cards = nil
    UserData['Credits'] = 100
end