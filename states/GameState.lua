GameState = Class{__includes = BaseState}

function GameState:init()
    Evolution = love.graphics.newImage('Graphics/Evolution.png')
    EvolutionMax = love.graphics.newImage('Graphics/EvolutionMax.png')

    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    P1_deck = {}
    P2_deck = {}
    Projectiles = {}
    Weapons = {}
    winner = 'none'
    gamespeed = 1
    local P1column = -1
    local P2column = 12
    local row_correctment = 0

    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = -1 - i / 6 
            P2column = 12 + i / 6 
            row_correctment = i
        end
        row = i - row_correctment
        if P1_deck_cards[i] ~= nil then
            if P1_deck_cards[i][1] ~= nil then
                P1_deck[i] = Card(P1_deck_cards[i][1],row,P1column,1,i,P1_deck_cards[i][2],P1_deck_cards[i][3])
            else
                P1_deck[i] = Card(P1_deck_cards[i],row,P1column,1,i)
            end
        end
        if P2_deck_cards[i] ~= nil then
            if P2_deck_cards[i][1] ~= nil then
                P2_deck[i] = Card(P2_deck_cards[i][1],row,P2column,2,i,P2_deck_cards[i][2],P2_deck_cards[i][3])
            else
                P2_deck[i] = Card(P2_deck_cards[i],row,P2column,2,i)
            end
        end
    end
    P1column = nil
    P2column = nil
    row_correctment = nil
end

function GameState:enter(Background)
    background['Type'] = Background[2]
    background['Seek'] = Background[3]
    if background['Type'] == 'video' then
        background['Background'] = love.graphics.newVideo('Backgrounds/' .. Background[1])
    else
        background['Background'] = love.graphics.newImage('Backgrounds/' .. Background[1])
    end

    songs[0] = love.audio.newSource('Music/' .. Background[7],'stream')
    songs[0]:play()
    calculate_queue_length()

    if Background[4] == nil then r = 0 else r = Background[4] end
    if Background[5] == nil then g = 0 else g = Background[5] end
    if Background[6] == nil then b = 0 else b = Background[6] end
    gui[1] = Button('switch_state',{'HomeState'},'Main Menu',font80,nil,35,20,r,g,b)
    gui[2] = Button('pause',nil,'Pause',font100,nil,1591,0,r,g,b) -- 35 pixels from right as font100:getWidth('Pause') = 294
    gui[3] = Slider(1591,130,300,16,'gamespeed_slider',0.3,0.3,0.3,r,g,b,0.25,0.25)

    if background['Seek'] > 1 then --All levels have at least a 1 second delay before spawing characters
        timer = 0 - (background['Seek'] - 1)
    else
        timer = 0
    end
    move_aim_timer = timer
    attack_timer = timer - 0.9
end

function CheckRowBelowEmpty(player,x)
    if player == 1 then
        deck = P1_deck
    else
        deck = P2_deck
    end
    if deck[x+1] == nil and deck[x+7] == nil and deck[x+13] == nil then
        row = x+1
        for i=0,2,1 do
            if deck[x] ~= nil then
                deck[x].row = row
                deck[x+1] = deck[x]
                deck[x] = nil
            end
            x = x + 6
        end
    end
end

function CheckRowAboveEmpty(player,x)
    if player == 1 then
        deck = P1_deck
    else
        deck = P2_deck
    end
    if (not(deck[x-2] == nil and deck[x+4] == nil and deck[x+10]) == nil) or not(
        deck[x-3] == nil and deck[x+3] == nil and deck[x+9] == nil) and x == 3 then return end
    if deck[x-1] == nil and deck[x+5] == nil and deck[x+11] == nil then
        row = x-1
        for i=0,2,1 do
            if deck[x] ~= nil then
                deck[x].row = row
                deck[x-1] = deck[x]
                deck[x] = nil
            end
            x = x + 6
        end
    end
end

function Check2TopRowsEmpty(player)
    if player == 1 then
        deck = P1_deck
    else
        deck = P2_deck
    end
    if deck[0] == nil and deck[6] == nil and deck[12] == nil and
    deck[1] == nil and deck[7] == nil and deck[13] == nil and
    not(deck[4] == nil and deck[10] == nil and deck[16] == nil) and
    not(deck[5] == nil and deck[11] == nil and deck[17] == nil) then
        y = 2
        for i=0,4,1 do
            x = y
            row = x-1
            for i=0,2,1 do
                if deck[x] ~= nil then
                    deck[x].row = row
                    deck[x-1] = deck[x]
                    deck[x] = nil
                end
                x = x + 6
            end
            y = y + 1
        end
    end
end

function Check2BottomRowsEmpty(player)
    if player == 1 then
        deck = P1_deck
    else
        deck = P2_deck
    end
    if deck[4] == nil and deck[10] == nil and deck[16] == nil and
    deck[5] == nil and deck[10] == nil and deck[17] == nil and
    not(deck[0] == nil and deck[6] == nil and deck[12] == nil) and
    not(deck[1] == nil and deck[7] == nil and deck[13] == nil) then
        y = 4
        for i=0,4,1 do
            x = y
            row = x+1
            for i=0,2,1 do
                if deck[x] ~= nil then
                    deck[x].row = row
                    deck[x+1] = deck[x]
                    deck[x] = nil
                end
                x = x + 6
            end
            y = y - 1
        end
    end
end

function CheckOnlyRow1and2Remain(player)
    if player == 1 then
        deck = P1_deck
    else
        deck = P2_deck
    end
    if deck[0] == nil and deck[6] == nil and deck[12] == nil and
    deck[3] == nil and deck[9] == nil and deck[15] == nil and
    deck[4] == nil and deck[10] == nil and deck[16] == nil and
    deck[5] == nil and deck[11] == nil and deck[17] == nil and 
    not(deck[1] == nil and deck[7] == nil and deck[13] == nil) and
    not(deck[2] == nil and deck[8] == nil and deck[14] == nil) then
        y = 2
        for i=0,2,1 do
            x = y
            row = x+1
            for i=0,2,1 do
                if deck[x] ~= nil then
                    deck[x].row = row
                    deck[x+1] = deck[x]
                    deck[x] = nil
                end
                x = x + 6
            end
            y = y - 1
        end
    end
end

function CheckOnlyRow3and4Remain(player)
    if player == 1 then
        deck = P1_deck
    else
        deck = P2_deck
    end
    if deck[0] == nil and deck[6] == nil and deck[12] == nil and
    deck[1] == nil and deck[7] == nil and deck[13] == nil and
    deck[2] == nil and deck[8] == nil and deck[14] == nil and
    deck[5] == nil and deck[11] == nil and deck[17] == nil and 
    not(deck[3] == nil and deck[9] == nil and deck[15] == nil) and
    not(deck[4] == nil and deck[10] == nil and deck[16] == nil) then
        y = 3
        for i=0,2,1 do
            x = y
            row = x-1
            for i=0,2,1 do
                if deck[x] ~= nil then
                    deck[x].row = row
                    deck[x-1] = deck[x]
                    deck[x] = nil
                end
                x = x + 6
            end
            y = y + 1
        end
    end
end


function GameState:back()
    pause()
end

function GameState:update(dt)
    if love.keyboard.wasPressed('space') then
        pause()
    end

    --Left/right arrow adjust gamespeed, above dt = dt * gamespeed so not affected by gamespeed
    if mouseTouching == gui[3] then
        if love.keyboard.wasDown('left') then
            gui[3]:update_percentage(gui[3].percentage - (dt*held_time^3)/4,false)
        end
        if love.keyboard.wasDown('right') then
            gui[3]:update_percentage(gui[3].percentage + (dt*held_time^3)/4,false)
        end
        if love.keyboard.wasDown('left') or love.keyboard.wasDown('right') then
            held_time = held_time + dt
        else
            held_time = 0.5
        end
    end

    if paused == false and winner == 'none' then
        dt = dt * gamespeed
        timer = timer + dt
        if timer >= 7.4 then timer = timer - 1 end
        move_aim_timer = move_aim_timer + dt
        attack_timer = attack_timer + dt

        for k, pair in pairs(P1_deck) do
            P1_deck[k]:update(dt)
        end
        for k, pair in pairs(P2_deck) do
            P2_deck[k]:update(dt)
        end

        if move_aim_timer >= 1 then
            move_aim_timer = move_aim_timer - 1
            
            for k, pair in pairs(P1_deck) do
                P1_deck[k]:move()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:move()
            end 
            if timer > 3 then
                CheckRowBelowEmpty(1,1)
                CheckRowBelowEmpty(1,0)
                CheckRowBelowEmpty(2,1)
                CheckRowBelowEmpty(2,0)
                CheckRowAboveEmpty(1,3)
                CheckRowAboveEmpty(1,4)
                CheckRowAboveEmpty(1,5)
                CheckRowAboveEmpty(2,3)
                CheckRowAboveEmpty(2,4)
                CheckRowAboveEmpty(2,5)
                Check2TopRowsEmpty(1)
                Check2TopRowsEmpty(2)
                Check2BottomRowsEmpty(1)
                Check2BottomRowsEmpty(2)
                CheckOnlyRow3and4Remain(1)
                CheckOnlyRow3and4Remain(2)
                CheckOnlyRow1and2Remain(1)
                CheckOnlyRow1and2Remain(2)
            end

            for k, pair in pairs(P1_deck) do
                P1_deck[k]:position()
            end
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:position()
            end

            for k, pair in pairs(P1_deck) do
                P1_deck[k]:aim()
            end
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:aim()
            end
        end

        if attack_timer >= 1 then
            attack_timer = attack_timer - 1

            for k, pair in pairs(P1_deck) do
                P1_deck[k].dodge = 0
                P1_deck[k].attacks_taken = 0
            end
            for k, pair in pairs(P2_deck) do
                P2_deck[k].dodge = 0
                P2_deck[k].attacks_taken = 0
            end

            for k, pair in pairs(P1_deck) do
                P1_deck[k]:attack()
            end
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:attack()
            end

            for k, pair in pairs(P1_deck) do
                P1_deck[k]:check_health()
            end
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:check_health()
            end
            
            if not next(P1_deck) then
                P1_deck = nil
            end
            if not next(P2_deck) then
                P2_deck = nil
            end
            if P1_deck == nil or P2_deck == nil then
                if P1_deck == nil and P2_deck == nil then 
                    winner = 'Draw'
                elseif P1_deck == nil then
                    winner = 'P2'
                elseif P2_deck == nil then
                    winner = 'P1'
                end
                Projectiles = nil
                Weapons = nil
                collectgarbage()
            end
        end
    end
end

function GameState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            P1_deck[k]:render()
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            P2_deck[k]:render()
        end
    end

    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            if P1_deck[k].weapon ~= nil then
                P1_deck[k].weapon:render()
            end
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            if P2_deck[k].weapon ~= nil then
                P2_deck[k].weapon:render()
            end
        end
    end

    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            if P1_deck[k].projectile ~= nil then
                P1_deck[k].projectile:render()
            end
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            if P2_deck[k].projectile ~= nil then
                P2_deck[k].projectile:render()
            end
        end
    end

    if winner ~= 'none' then 
        love.graphics.print({{r,g,b},'Winner: ' .. winner},35,110)
    end
end

function GameState:exit()
    P1_deck = nil
    P2_deck = nil
    deck = nil
    P1_deck_cards = {}
    P2_deck_cards = {}
    Projectiles = nil
    Weapons = nil
    Evolution = nil
    EvolutionMax = nil
    exit_state()
end