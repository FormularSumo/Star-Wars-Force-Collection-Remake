function endor()
    P2_deck_cards[0] = {'Tokkat',60,4}
    P2_deck_cards[1] = {'Paploo',60,4}
    P2_deck_cards[2] = {'Wicket W Warrick',60,4}
    P2_deck_cards[3] = {'Teebo',60,4}
    P2_deck_cards[4] = {'Chief Chirpa',60,4}
    P2_deck_cards[5] = {'Logray',60,4}

    gStateMachine:change('GameState',{'Endor.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March Duet.mp3'})
end

function kamino()
    P2_deck_cards[0] = {'Captain Vaughn',60,4}
    P2_deck_cards[1] = {'Commander Gree',60,4}
    P2_deck_cards[2] = {'Commander Bacara',60,4}
    P2_deck_cards[3] = {'Commander Bly',60,4}
    P2_deck_cards[4] = {'ARC Trooper',60,4}
    P2_deck_cards[5] = {'Clone Commando',60,4}
    P2_deck_cards[6] = {'ARC Trooper Echo',60,4}
    P2_deck_cards[7] = {'ARC Trooper Fives',60,4}
    P2_deck_cards[8] = {'ARC Trooper Jesse',60,4}
    P2_deck_cards[9] = {'Commander Cody',60,4}
    P2_deck_cards[10] = {'Captain Rex',60,4}
    P2_deck_cards[11] = {'322nd Clone Trooper',60,4}
    P2_deck_cards[12] = {'327th Clone Trooper',60,4}
    P2_deck_cards[13] = {'501st Clone Trooper',60,4}
    P2_deck_cards[14] = {'212th Clone Trooper',60,4}
    P2_deck_cards[15] = {'Commander Wolffe',60,4}
    P2_deck_cards[16] = {'Coruscant Guard Clone Trooper',60,4}
    P2_deck_cards[17] = {'Clone Commando Gregor',60,4}

    gStateMachine:change('GameState',{'Kamino.jpg', 'photo', 0, 1, 1 ,1, 'Clone Wars Theme.oga'})
end

function throne_room()
    P2_deck_cards[1] = {'Royal Guard',60,4}
    P2_deck_cards[2] = {'Emperor Palpatine',60,4}
    P2_deck_cards[3] = {'Darth Vader',60,4}
    P2_deck_cards[4] = {'Royal Guard',60,4}
   
    gStateMachine:change('GameState',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March Piano.oga'})
end

function maxed_dark_side()
    P2_deck_cards[0] = {'Darth Marr',60,4}
    P2_deck_cards[1] = {'Grand Inquisitor',60,4}
    P2_deck_cards[2] = {'Darth Vader',60,4}
    P2_deck_cards[3] = {'Darth Sion',60,4}
    P2_deck_cards[4] = {'Ninth Sister',60,4}
    P2_deck_cards[5] = {'Count Dooku',60,4}
    P2_deck_cards[6] = {'Seventh Sister',60,4}
    P2_deck_cards[7] = {'Darth Malgus',60,4}
    P2_deck_cards[8] = {'Darth Revan',60,4}
    P2_deck_cards[9] = {'Emperor Palpatine',60,4}
    P2_deck_cards[10] = {'Supreme Leader Snoke',60,4}
    P2_deck_cards[11] = {'Darth Bane',60,4}
    P2_deck_cards[12] = {'Fifth Brother',60,4}
    P2_deck_cards[13] = {'Darth Nihilus',60,4}
    P2_deck_cards[14] = {'The Son',60,4}
    P2_deck_cards[15] = {'Sith Eternal Emperor',60,4}
    P2_deck_cards[16] = {'Trilla Suduri',60,4}
    P2_deck_cards[17] = {'Eighth Brother',60,4}

    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes.ogv', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes.jpg', 'photo', 0, 0, 0, 0, 'Binary Sunset.oga'})
    end
end

function maxed_light_side()
    P2_deck_cards[0] = {'Ahsoka Tano Fulcrum',60,4}
    P2_deck_cards[1] = {'Hermit Luke Skywalker',60,4}
    P2_deck_cards[2] = {'Jedi Knight Revan',60,4}
    P2_deck_cards[3] = {'Yoda',60,4}
    P2_deck_cards[4] = {'Ahsoka Tano Mandalorian',60,4}
    P2_deck_cards[5] = {'Ahsoka Tano S7',60,4}
    P2_deck_cards[6] = {'Jedi Knight Luke Skywalker',60,4}
    P2_deck_cards[7] = {'Meetra Surik',60,4}
    P2_deck_cards[8] = {'Mace Windu',60,4}
    P2_deck_cards[9] = {'Jedi Knight Anakin Skywalker',60,4}
    P2_deck_cards[10] = {'Hermit Yoda',60,4}
    P2_deck_cards[11] = {'Jedi Master Obi-Wan Kenobi',60,4}
    P2_deck_cards[12] = {'Pong Krell',60,4}
    P2_deck_cards[13] = {'Kit Fisto',60,4}
    P2_deck_cards[14] = {'The Daughter',60,4}
    P2_deck_cards[15] = {'Kreia',60,4}
    P2_deck_cards[16] = {'Quinlan Vos',60,4}
    P2_deck_cards[17] = {'Lana Beniko',60,4}
    
    gStateMachine:change('GameState',{'Voss.jpg', 'photo', 0, 1, 1, 1, 'The Mandalorian.oga'})
end

function maxed()
    P2_deck_cards[0] = {'Darth Vader',60,4}
    P2_deck_cards[1] = {'Yoda',60,4}
    P2_deck_cards[2] = {'Jedi Knight Revan',60,4}
    P2_deck_cards[3] = {'Zillo Beast',60,4}
    P2_deck_cards[4] = {'Mace Windu',60,4}
    P2_deck_cards[5] = {'Ahsoka Tano Mandalorian',60,4}
    P2_deck_cards[6] = {'Jedi Knight Anakin Skywalker',60,4}
    P2_deck_cards[7] = {'Emperor Palpatine',60,4}
    P2_deck_cards[8] = {'The Father',60,4}
    P2_deck_cards[9] = {'Darth Revan',60,4}
    P2_deck_cards[10] = {'Hermit Luke Skywalker',60,4}
    P2_deck_cards[11] = {'Meetra Surik',60,4}
    P2_deck_cards[12] = {'Darth Nihilus',60,4}
    P2_deck_cards[13] = {'The Daughter',60,4}
    P2_deck_cards[14] = {'The Son',60,4}
    P2_deck_cards[15] = {'Force Priestess',60,4}
    P2_deck_cards[16] = {'Sith Eternal Emperor',60,4}
    P2_deck_cards[17] = {'Bendu',60,4}

    gStateMachine:change('GameState',{'Belsavis.jpg', 'photo', 0, 0, 0 ,0, 'Throne Room.oga'})
end