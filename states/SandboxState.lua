SandboxState = Class{__includes = BaseState}

function SandboxState:enter()
    gui[1] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font70,nil,'centre',20)

    gui['Player 1 label'] = Text('Player 1',font60,'centre',140)
    gui['Player 1 deck'] = Text(retriveDeck(Settings['P1_selection'])[1],font80,'centre',220)
    gui[2] = Button(function() self:updateCarousel('Player 1 deck','left') end,nil,nil,'Left Arrow',VIRTUALWIDTH/2-225,184,nil,nil,nil,true)
    gui[3] = Button(function() self:updateCarousel('Player 1 deck','right') end,nil,nil,'Right Arrow',VIRTUALWIDTH/2+225,184,nil,nil,nil,true)

    gui['Player 2 label'] = Text('Player 2',font60,'centre',340)
    gui['Player 2 deck'] = Text(retriveDeck(Settings['P2_selection'])[1],font80,'centre',420)
    gui[4] = Button(function() self:updateCarousel('Player 2 deck','left') end,nil,nil,'Left Arrow',VIRTUALWIDTH/2-225,384,nil,nil,nil,true)
    gui[5] = Button(function() self:updateCarousel('Player 2 deck','right') end,nil,nil,'Right Arrow',VIRTUALWIDTH/2+225,384,nil,nil,nil,true)

    gui['Background label'] = Text('Background',font60,'centre',540)
    gui['Background'] = Text(retriveBackground(Settings['background_selection'])[1],font80,'centre',620)
    gui[6] = Button(function() self:updateCarousel('Background','left') end,nil,nil,'Left Arrow',VIRTUALWIDTH/2-285,584,nil,nil,nil,true)
    gui[7] = Button(function() self:updateCarousel('Background','right') end,nil,nil,'Right Arrow',VIRTUALWIDTH/2+285,584,nil,nil,nil,true)

    gui['Music label'] = Text('Music',font60,'centre',740)
    gui['Music'] = Text(retriveMusic(Settings['music_selection'])[1],font80,'centre',820)
    gui[8] = Button(function() self:updateCarousel('Music','left') end,nil,nil,'Left Arrow',VIRTUALWIDTH/2-190,784,nil,nil,nil,true)
    gui[9] = Button(function() self:updateCarousel('Music','right') end,nil,nil,'Right Arrow',VIRTUALWIDTH/2+190,784,nil,nil,nil,true)

    gui[10] = Button(function() gStateMachine:change('GameState',{
        retriveBackground(Settings['background_selection'])[1],
        retriveMusic(Settings['music_selection'])[2],
        retriveDeck(Settings['P2_selection'])[2],
        retriveDeck(Settings['P1_selection'])[2]
    },nil,nil) end,'Begin',font100,nil,'centre',950)

end

function retriveDeck(index) --Can't make self or can't reference in updateCarousel annoyingly
    if index == 'max' then return 15
    elseif index == 1 then
        return {'Deck 1','Player 1 deck.txt'}
    elseif index == 2 then
        return {'Deck 2','Player 1 deck 2.txt'}
    elseif index == 3 then
        return {'Deck 3','Player 1 deck 3.txt'}
    elseif index == 4 then
        return {'Endor',endor}
    elseif index == 5 then
        return {'Mos Eisley', mosEisley}
    elseif index == 6 then
        return {'Mos Espa',mosEspa}
    elseif index == 7 then
        return {'Throne Room',throneRoom}
    elseif index == 8 then
        return {'Kamino',kamino}
    elseif index == 9 then
        return {'Geonosis',geonosis}
    elseif index == 10 then
        return {'Dathomir',dathomir}
    elseif index == 11 then
        return {'Sith Trimuvirate',sithTriumvirate}
    elseif index == 12 then
        return {'Jedi Council Chamber',jediCouncilChamber}
    elseif index == 13 then
        return {'Maxed Light Side',maxedLightSide}
    elseif index == 14 then
        return {'Maxed Dark Side',maxedDarkSide}
    elseif index == 15 then
        return {'Maxed',maxed}
    end
end

function retriveBackground(index) --Can't make self or can't reference in updateCarousel annoyingly
    if index == 'max' then return 11
    elseif index == 1 then
        return {'Belsavis'}
    elseif index == 2 then
        return {'Dathomir'}
    elseif index == 3 then
        return {'Death Star Control Room'}
    elseif index == 4 then
        return {'Endor'}
    elseif index == 5 then
        return {'Geonosis'}
    elseif index == 6 then
        return {'Kamino'}
    elseif index == 7 then
        return {'Order 66'}
    elseif index == 8 then
        return {'Sand Dunes'}
    elseif index == 9 then
        return {'Sith Triumvirate'}
    elseif index == 10 then
        return {'Starry Sky'}
    elseif index == 11 then
        return {'Voss'}
    end
end

function retriveMusic(index) --Can't make self or can't reference in updateCarousel annoyingly
    if index == 'max' then return 10
    elseif index == 1 then
        return {'Across The Stars', 'Across The Stars.oga'}
    elseif index == 2 then
        return {'Ahsoka\'s Theme', 'Ahsoka\'s Theme.oga'}
    elseif index == 3 then
        return {'Binary Sunset', 'Binary Sunset.oga'}
    elseif index == 4 then
        return {'Clone Wars Theme', 'Clone Wars Theme.oga'}
    elseif index == 5 then
        return {'Fallen Order', 'Fallen Order.oga'}
    elseif index == 6 then
        return {'Imperial March Duet', 'Imperial March Duet.mp3'}
    elseif index == 7 then
        return {'Imperial March Piano', 'Imperial March Piano.oga'}
    elseif index == 8 then
        return {'The Mandalorian', 'The Mandalorian.oga'}
    elseif index == 9 then
        return {'The Old Republic', 'The Old Republic.oga'}
    elseif index == 10 then
        return {'Throne Room', 'Throne Room.oga'}
    end
end

function SandboxState:updateCarousel(carouselName,direction)
    local carousel
    local retrive
    if carouselName == 'Player 1 deck' then
        carousel = 'P1_selection'
        retrive = retriveDeck
    elseif carouselName == 'Player 2 deck' then
        carousel = 'P2_selection'
        retrive = retriveDeck
    elseif carouselName == 'Background' then
        carousel = 'background_selection'
        retrive = retriveBackground
    elseif carouselName == 'Music' then
        carousel = 'music_selection'
        retrive = retriveMusic
    end

    if direction == 'right' then
        if Settings[carousel] == retrive('max') then
            Settings[carousel] = 1
        else
            Settings[carousel] = Settings[carousel] + 1
        end
    else
        if Settings[carousel] == 1 then
            Settings[carousel] = retrive('max')
        else
            Settings[carousel] = Settings[carousel] - 1
        end
    end

    gui[carouselName]:updateText(retrive(Settings[carousel])[1])
    love.filesystem.write('Settings.txt',binser.s(Settings))
end

function SandboxState:back()
    gStateMachine:change('HomeState',true,true)
end