function love.load()
    --Libraries and other files that are required
    push = require 'push'
    Class = require 'class'
    bitser = require 'bitser/bitser'
    
    require 'Card'
    require 'Button'
    require 'Slider'
    require 'Text'
    require 'Characters/Character stats'
    require 'StateMachine'
    require 'states/BaseState'
    require 'states/GameState'
    require 'states/DeckeditState'
    require 'states/HomeState'
    require 'states/SettingsState'
    require 'states/CampaignState'
    require 'campaign'
    require 'other functions'
    require 'Projectile'
    require 'Weapon'
    require 'Card editor'

    -- app window title
    love.window.setTitle('Star Wars Force Collection Remake')

    -- folder that app data is stored in
    love.filesystem.setIdentity('Star Wars Force Collection Remake')

    --Operating System
    OS = love.system.getOS()

    VIRTUAL_WIDTH = 1920
    VIRTUAL_HEIGHT = 1080

    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))) --Randomises randomiser each time program is run. String is reversed to preserve low bits in time (eg second, millisecodns) rather than high bits (years, hours) when rounding - see http://lua-users.org/wiki/MathLibraryTutorial
    math.random()
    
    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 0, 0, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    -- load fonts
    font50 = love.graphics.newFont(50)
    font60 = love.graphics.newFont(60)
    font80 = love.graphics.newFont(80)
    -- font80SW = love.graphics.newFont('Fonts/Distant Galaxy.ttf',80)
    -- font80SW_runes = love.graphics.newFont('Fonts/Aurebesh Bold.ttf',80)
    font100 = love.graphics.newFont(100)
    love.graphics.setFont(font80)
    
    gui = {}
    songs = {}
    background = {}
    paused = false

    P1_deck_cards = {}
    P2_deck_cards = {}

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    mouseDown = false
    mouseTrapped = false
    mouseTrapped2 = false
    mouseLastX = 0
    mouseLastY = 0
    focus = true
    joysticks = love.joystick.getJoysticks()

    if love.filesystem.getInfo('Settings.txt') == nil then
        Settings = {
            ['pause_on_loose_focus'] = true,
            ['volume_level'] = 0.5,
            ['FPS_counter'] = false
        }
        bitser.dumpLoveFile('Settings.txt',Settings)
    end

    Settings = bitser.loadLoveFile('Settings.txt')
    love.audio.setVolume(Settings['volume_level'])

    if love.filesystem.getInfo('Player 1 deck.txt') == nil then
        P1_deck_cards = {}
        bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
    end

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['HomeState'] = function() return HomeState() end,
        ['GameState'] = function() return GameState() end,
        ['SettingsState'] = function() return SettingsState() end,
        ['CampaignState'] = function() return CampaignState() end,
        ['DeckeditState'] = function() return DeckeditState() end,
    }
    gStateMachine:change('HomeState')
end

function P1_deck_edit(position,name)
    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    
    P1_deck_cards[position] = name

    bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    --F11 toggles between fullscreen and maximised
    if key == 'f11' then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true)
        else
            love.window.setFullscreen(false)
            love.window.maximize()
        end
    end

    --M mutes/unmutes
    if key == 'm' then
        if love.audio.getVolume() == 0 then
            love.audio.setVolume(0.5)
        else
            love.audio.setVolume(0)
        end
        Settings['volume_level'] = love.audio.getVolume()
        bitser.dumpLoveFile('Settings.txt', Settings)
        if gui['Volume Slider'] ~= nil then
            gui['Volume Slider'].percentage = love.audio.getVolume()
        end
    end 

    --Escape on Android is mapped to the back key so shouldn't be used for exiting fullscreen
    if key == 'escape' and OS ~= 'Android' then
        love.window.setFullscreen(false)
        love.window.maximize()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] 
end

function love.mousereleased(x,y,button)
    love.mouse.buttonsPressed[button] = true
end

function love.touchreleased()
    love.mouse.buttonsPressed[1] = true
end

function love.joystickreleased(joystick,button)
    if button == 1 then
        love.mouse.buttonsPressed[1] = true
    end
end

function love.focus(InFocus)
    focus = InFocus
    if Settings['pause_on_loose_focus'] then pause(not focus) end --Pause/play game if pause_on_loose_focus setting is on
end

function love.update(dt)
    --Handle mouse inputs
    if love.mouse.isDown(1,2,3) then
        update_mouse_position()
    end

    --Handle joystick inputs
    if joysticks[1] then
        if joysticks[1]:isDown(1) then 
            update_mouse_position()
        end
        
        leftx = dt * 1000 * joysticks[1]:getGamepadAxis('leftx')
        lefty = dt * 1000 * joysticks[1]:getGamepadAxis('lefty')
        if focus and (leftx > 1 or leftx < -1 or lefty > 1 or lefty < -1) then --Only if in focus because you don't want joysticks to continue moving mouse when you're not in program and buffer because otherwise joysticks are so sensitive they trap mouse inside game unless you alt-tab
            love.mouse.setPosition(
                love.mouse.getX() + (dt * 1000 * joysticks[1]:getGamepadAxis('leftx')),
                love.mouse.getY() + (dt * 1000 * joysticks[1]:getGamepadAxis('lefty')))
        end

        if joysticks[1]:isGamepadDown('dpleft') then
            love.mouse.setPosition(love.mouse.getX()-(dt*1000),love.mouse.getY())
        end
        if joysticks[1]:isGamepadDown('dpright') then
            love.mouse.setPosition(love.mouse.getX()+(dt*1000),love.mouse.getY())
        end
        if joysticks[1]:isGamepadDown('dpup') then
            love.mouse.setPosition(love.mouse.getX(),love.mouse.getY()-(dt*1000))
        end
        if joysticks[1]:isGamepadDown('dpdown') then
            love.mouse.setPosition(love.mouse.getX(),love.mouse.getY()+(dt*1000))
        end
    end

    --Manage song queue
    if songs[0] ~= nil then
        if songs[current_song]:isPlaying() == false and paused == false then
            if next_song <= queue_length then
                songs[next_song]:play()
                current_song = next_song
                next_song = next_song + 1
            else
                next_song = 0
            end
        end
    end

    --Manage background video looping and pausing
    if background['Type'] == 'video' then
        if paused == true then
            background['Background']:pause()
        else
            if background['Background']:isPlaying() == false then
                background['Background']:play()
            end
            testForBackgroundImageLoop(background['Background'],background['Seek'])
        end
    end

    --Update GUI elements
    for k, pair in pairs(gui) do
        pair:update()
    end

    --Update state machine
    gStateMachine:update(dt)

    --Reset table of clicked keys/mousebuttons so last frame's inputs aren't used next frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    if mouseDown == false then mouseTrapped = false mouseTrapped2 = false end
    mouseDown = false
end

function love.draw()
    push:start()
    love.graphics.setColor(1, 1, 1, 1)

    if background['Background'] then
        love.graphics.draw(background['Background'])
    end

    if background['Canvas'] then
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(background['Canvas'])
        love.graphics.setBlendMode("alpha")
    end

    gStateMachine:render()
    for k, pair in pairs(gui) do
        pair:render()
    end
    if Settings['FPS_counter'] == true then
        love.graphics.print({{0,255,0,255}, 'FPS: ' .. tostring(love.timer.getFPS())}, font50, 1680, 1020)
    end

    -- love.graphics.print(tostring(mouseTrapped) .. ' ' .. tostring(mouseTrapped2))
    -- if P1_deck then
    --     if P1_deck[1] then
    --         love.graphics.print(tostring(P1_deck[1].name .. ' ' .. P1_deck[1].row),0,200)
    --     end
    --     if P1_deck[2] then
    --         love.graphics.print(tostring(P1_deck[2].name .. ' ' .. P1_deck[2].row),0,300)        
    --     end     
    -- end
    -- if temporary then
    --     love.graphics.print(tostring(temporary.name .. ' ' .. temporary.row),0,400)
    -- end
    -- if temporary2 then
    --     love.graphics.print(tostring(temporary2.name .. ' ' .. temporary2.row),0,500)
    -- end
    push:finish()
end