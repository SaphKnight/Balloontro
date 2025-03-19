--- STEAMODDED HEADER
--- MOD_NAME: Balloontro
--- MOD_ID: BALLOONTRO
--- MOD_AUTHOR: SapphireKnight, Greenkibble
--- MOD_DESCRIPTION: A Balloon SMP inspired Balatro mod
--- PREFIX: bsmp
-----------------------------------------
------------MOD CODE --------------------

SMODS.Atlas{
    key = 'BSMPJokers',
    path = 'Jokers.png',
    px = 71,
    py = 95,
}

SMODS.Joker{ -- SocksBX Joker
    key = 'socksbx',
    loc_txt = {
        name = 'SocksBX',
        text = {
            'Gives {C:mult}+1{} Mult for each',
            '{C:hearts}Hearts{C:attention} Card{} in your full deck',
            '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
        }
    },
    config = { extra = {socks_mult = 0}},
    loc_vars = function(self,info_queue,card)
        return { vars = {card.ability.extra.socks_mult}}
    end,
    rarity = 2,
    atlas = 'BSMPJokers',
    pos = {x = 0, y = 0},
    cost = 5,
    
    calculate = function(self,card,context)
        if context.joker_main then
            card.ability.extra.socks_mult=0
            for k,v in pairs (G.playing_cards) do
                if v:is_suit('Hearts',true) then card.ability.extra.socks_mult = card.ability.extra.socks_mult+1 end
        end
            return {mult_mod = card.ability.extra.socks_mult,
                    message = localize {type='variable',key='a_mult',vars={card.ability.extra.socks_mult}}
                }
            end
        end
}

SMODS.Joker { -- Skullvolver Joker
    key = 'skullvolver',
    loc_txt = {
        name = 'Skullvolver',
        text = {
            'When a {C:hearts}Hearts{} card is',
            'deleted, this card gains {C:mult}+2{} Mult',
            '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}'
        }
    },
    config = {extra = {skull_mult = 0}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.skull_mult}}
    end,
    rarity = 2,
    atlas = 'BSMPJokers',
    pos = {x = 1, y = 0},
    cost = 5,
    calculate = function(self,card,context)
        if context.remove_playing_cards then
            local hearts_cards = 0
            for k, v in ipairs(context.removed) do
                if v:is_suit('Hearts',true) then hearts_cards = hearts_cards + 2 
                end
            end
            if hearts_cards > 0 then
                card.ability.extra.skull_mult = card.ability.extra.skull_mult + hearts_cards
            end
            if context.cards_destroyed then
                local hearts_cards = 0
                for k, v in ipairs(context.glass_shattered) do
                    if v:is_suit('Hearts',true) then hearts_cards = hearts_cards + 2 
                    end
                end
                if hearts_cards > 0 then
                    card.ability.extra.skull_mult = card.ability.extra.skull_mult + hearts_cards
                end
                return
            end
        end
        if context.joker_main then
            return {mult_mod = card.ability.extra.skull_mult,
                    message = localize {type='variable',key='a_mult',vars={card.ability.extra.skull_mult}}
                }
            end
        end
}

SMODS.Joker { -- Buggle Joker
    key = 'buggle',
    loc_txt = {
        name = 'Buggle',
        text = {
            'Gains {C:chips}+10{} Chips when a',
            '{C:attention}Consumable{} is used',
            '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    config = {extra = {bug_chips = 0}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.bug_chips}}
    end,
    rarity = 1,
    atlas = 'BSMPJokers',
    pos = {x = 2, y = 0},
    cost = 3,
    calculate = function(self,card,context)
        if context.using_consumeable then
            card.ability.extra.bug_chips = card.ability.extra.bug_chips + 10
            G.E_MANAGER:add_event(Event({
                func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_chips',vars={card.ability.extra.bug_chips}}}); return true
                end}))
            return
        end
        if context.joker_main then
            return {chip_mod = card.ability.extra.bug_chips,
                    message = localize {type='variable',key='a_chips',vars={card.ability.extra.bug_chips}}
                }
            end
        end
}

SMODS.Joker { -- Soma Joker
    key = 'soma',
    loc_txt = {
        name = 'Soma',
        text = {
            'When Blind is selected,',
            '{C:attention}Destroy{} the leftmost Joker',
            'and gain a {C:spectral}Spectral{} card'
        }
    },
    config = {extra = {}},
    loc_vars = function(self,info_queue,card)
    end,
    rarity = 2,
    atlas = 'BSMPJokers',
    pos = {x = 5, y = 0},
    cost = 6,
    calculate = function(self,card,context)
        if context.setting_blind and not card.getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if not card.getting_sliced and not G.jokers.cards[1].ability.eternal and not G.jokers.cards[1].getting_sliced then
                local sliced_card = G.jokers.cards[1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                        local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'soma')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                }
            end
        end
    end
}

SMODS.Joker { -- Normie Joker
    key = 'normie',
    loc_txt = {
        name = 'Normie',
        text = {
            'When opening a {C:attention}Booster Pack{}',
            '{C:green}#1# in #2#{} chance of getting',
            'a random {C:dark_edition}Foil {C:blue}Common{C:attention} Joker{}'
        }
    },
    config = {extra = {prob = 6}},
    loc_vars = function(self,info_queue,card)
        return {vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.prob}}
    end,
    rarity = 1,
    atlas = 'BSMPJokers',
    pos = {x = 4, y = 0},
    cost = 3,
    calculate = function(self,card,context)
        if context.open_booster and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            if (pseudorandom('normie') < G.GAME.probabilities.normal / card.ability.extra.prob) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function ()
                        local card = create_card('Joker',G.jokers,nil,0,nil,nil,nil,'normie')
                        card:set_edition('e_foil',true)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        G.GAME.joker_buffer = 0
                        return true
                    end
                )}))
            end
        end
    end
}

SMODS.Joker { -- Woops Joker
    key = 'woops',
    loc_txt = {
        name = 'Woops',
        text = {
            'If played hand contains',
            'a {C:attention}Pair{}, {C:green}#1# in #2#{} Chance',
            'to upgrade level of',
            'played {C:attention}Poker Hand{}'
        }
    },
    config = {extra = {prob = 2}},
    loc_vars = function(self,info_queue,card)
        return {vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.prob}}
    end,
    rarity = 3,
    atlas = 'BSMPJokers',
    pos = {x = 3, y = 0},
    cost = 8,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
            if next(context.poker_hands['Pair']) and (pseudorandom('woops') < G.GAME.probabilities.normal / card.ability.extra.prob) then
                return {
                level_up = true,
                message = localize('k_level_up_ex')
                }
            end
        end
    end
}

SMODS.Joker { -- Val Joker
    key = 'val',
    loc_txt = {
        name = 'Val',
        text = {
            'Played {C:attention}Steel Cards{} give',
            '{X:mult,C:white}x#1#{C:attention} Mult{}'
        }
    },
    config = {extra = {val_xmult=1.6}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.val_xmult}}
    end,
    rarity = 1,
    atlas = 'BSMPJokers',
    pos = {x = 6, y = 0},
    cost = 4,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual then
            if context.other_card.ability.name == 'Steel Card' then
                return {
                    Xmult_mod = card.ability.extra.val_xmult,
                    message = localize {type='variable',key='a_xmult',vars={card.ability.extra.val_xmult}}
                }
            end
        end
    end
}

SMODS.Joker { -- Jame Joker
    key = 'jame',
    loc_txt = {
        name = 'Jame',
        text = {
            'If {C:attention}Scored Hand{} has',
            '5 Cards, gain {C:mult}+#1#{C:attention} Mult.{}'
        }
    },
    config = {extra = {jame_mult=15}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.jame_mult}}
    end,
    rarity = 1,
    atlas = 'BSMPJokers',
    pos = {x = 7, y = 0},
    cost = 5,
    calculate = function(self,card,context)
        if context.joker_main and #context.scoring_hand == 5 then
            return {
                mult_mod = card.ability.extra.jame_mult,
                message = localize {type='variable',key='a_mult',vars={card.ability.extra.jame_mult}}
            }
        end
    end
}

SMODS.Joker { -- Katy Joker
    key = 'katy',
    loc_txt = {
        name = 'Katy',
        text = {
            'Disable {C:attention}Boss Blinds{} that',
            '{C:attention}Debuff{} playing cards',
            '{C:inactive}(The Club, The Goad, The Window, The Plant,{}',
            '{C:inactive}The Pillar, The Head, and Verdant Leaf){}'
        }
    },
    config = {extra = {}},
    loc_vars = function(self,info_queue,card)
    end,
    rarity = 3,
    atlas = 'BSMPJokers',
    pos = {x = 8, y = 0},
    cost = 9,
    calculate = function(self,card,context)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            if G.GAME.blind.name == 'The Club' or G.GAME.blind.name == 'The Goad' or G.GAME.blind.name == 'The Window' or G.GAME.blind.name == 'The Plant' or 
            G.GAME.blind.name == 'The Pillar' or G.GAME.blind.name == 'The Head' or G.GAME.blind.name == 'Verdant Leaf' then
                G.GAME.blind:disable()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            end
        end
    end
}

SMODS.Joker { -- Ellie Joker
    key = 'ellie',
    loc_txt = {
        name = 'Ellie',
        text = {
            'If scored hand contains',
            '{C:attention}5 Cards{}, Gains {C:mult}Mult{} equal',
            'to played Poker Hand level',
            '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}'
        }
    },
    config = { extra = {ellie_mult = 0}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.ellie_mult}}
    end,
    rarity = 2,
    atlas = 'BSMPJokers',
    pos = {x = 9, y = 0},
    cost = 7,
    calculate = function(self,card,context)
        if context.before and #context.scoring_hand == 5 then
            hand_name = context.scoring_name
            card.ability.extra.ellie_mult = card.ability.extra.ellie_mult + G.GAME.hands[hand_name].level
            return {
                message = localize {type='variable',key='a_mult',vars={card.ability.extra.ellie_mult}}
            }
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.ellie_mult,
                message = localize {type='variable',key='a_mult',vars={card.ability.extra.ellie_mult}}
            }
        end
    end
}

SMODS.Joker { -- Jordan Joker
    key = 'jordan',
    loc_txt = {
        name = 'Jordan',
        text = {
            'Gains {C:white,X:mult}X0.1{C:attention} Mult{} when',
            'a {C:attention}Joker{} is bought.',
            '{C:inactive}(Currently {C:white,X:mult}X#1#{C:inactive} mult){}'
        }
    },
    config = {extra = {jordan_xmult = 1}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.jordan_xmult}}
    end,
    rarity = 3,
    atlas = 'BSMPJokers',
    pos = {x = 0, y = 1},
    cost = 8,
    calculate = function(self,card,context)
        if context.buying_card then
            if context.card.ability.set == 'Joker' then
                card.ability.extra.jordan_xmult = card.ability.extra.jordan_xmult + 0.1
                return {
                    message = localize {type='variable',key='a_xmult',vars={card.ability.extra.jordan_xmult}}
                }
            end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.jordan_xmult,
                message = localize {type='variable',key='a_xmult',vars={card.ability.extra.jordan_xmult}}
            }
        end
    end
}

SMODS.Joker { -- Gibson Joker
    key = 'gibson',
    loc_txt = {
        name = 'Gibson',
        text = {
            'When a {C:attention}Poker Hand{} is played,',
            'set its {C:attention}level{} to 1',
            'and give this card {X:mult,C:white}X0.25{} Mult',
            'for each level lost this way',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
        }
    },
    config = {extra = {gibson_xmult = 1}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.gibson_xmult}}
    end,
    rarity = 3,
    atlas = 'BSMPJokers',
    pos = {x = 1, y = 1},
    cost = 9,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
            hand_name = context.scoring_name
            if G.GAME.hands[hand_name].level > 1 then
                temp_level = (G.GAME.hands[hand_name].level - 1)
                level_down = 0 - temp_level
                level_up_hand(card, hand_name, nil, level_down)
                card.ability.extra.gibson_xmult = (temp_level * 0.25) + card.ability.extra.gibson_xmult
                return {
                    message = localize {type='variable',key='a_xmult',vars={card.ability.extra.gibson_xmult}}
                }
            end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.gibson_xmult,
                message = localize {type='variable',key='a_xmult',vars={card.ability.extra.gibson_xmult}}
            }
        end
    end
}

SMODS.Joker { -- Ausk Joker
    key = 'ausk',
    loc_txt = {
        name = 'Ausk',
        text = {
            'If played hand contains',
            'only {C:spades}Spades{} cards',
            '{C:green}#1# in #2#{} chance to make',
            'a random Joker {C:dark_edition}Negative{}'
        }
    },
    config = {extra = {prob = 8}},
    loc_vars = function(self,info_queue,card)
        return{vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.prob}}
    end,
    rarity = 2,
    atlas = 'BSMPJokers',
    pos = {x = 2, y = 1},
    cost = 7,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
            local play_spade = true
            for k, v in ipairs(G.play.cards) do
                if not v:is_suit('Spades',true) then
                    play_spade = false
                end
            end
            if (pseudorandom('ausk') < G.GAME.probabilities.normal / card.ability.extra.prob) and play_spade then
                local non_neg = {}
                for i=1, #G.jokers.cards do
                    if not G.jokers.cards[i].edition or not G.jokers.cards[i].edition.negative then
                        non_neg[#non_neg+1] = G.jokers.cards[i]
                    end
                end
                local new_neg = #non_neg > 0 and pseudorandom_element(non_neg,pseudoseed('ausk')) or nil
                if new_neg then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            new_neg:set_edition('e_negative',true)
                            return true
                        end
                        )
                    }))
                end
            end
        end
    end
}

SMODS.Joker { -- Sopy Joker
    key = 'sopy',
    loc_txt = {
        name = 'Sopy',
        text = {
            'Whenever a {C:planet}Planet{} card is',
            'used, {C:green}#1# in #2#{} chance to',
            'gain {C:money}$#3#{}',
        }
    },
    config = {extra = {prob = 3,sopy_money = 8}},
    loc_vars = function(self,info_queue,card)
        return{vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.prob,card.ability.extra.sopy_money}}
    end,
    rarity = 1,
    atlas = 'BSMPJokers',
    pos = {x = 3, y = 1},
    cost = 4,
    calculate = function(self,card,context)
        if context.using_consumeable then
            if (pseudorandom('sopy') < G.GAME.probabilities.normal / card.ability.extra.prob) and context.consumeable.ability.set == 'Planet' then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_dollars(card.ability.extra.sopy_money)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.sopy_money,colour = G.C.MONEY, delay = 0.45})
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { -- Ourwake Joker
    key = 'ourwake',
    loc_txt = {
        name = 'Ourwake',
        text = {
            'Gives {X:mult,C:white}X#1#{C:attention} Mult.{}',
            'For every played hand, increase',
            'the level of played hand by 2.',
            'Afterwards, loses {X:mult,C:white}X1{} Mult.'
        }
    },
    config = {extra = {ourwakeXMult=10}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.ourwakeXMult}}
    end,
    rarity = 4,
    atlas = 'BSMPJokers',
    pos = {x = 4, y = 1},
    soul_pos = {x = 3, y = 9},
    cost = 20,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
            hand_name = context.scoring_name
            level_up_hand(card, hand_name, nil, 2)
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.ourwakeXMult,
                message = localize {type='variable',key='a_xmult',vars={card.ability.extra.ourwakeXMult}}
            }
        end
        if context.cardarea == G.jokers and context.after then
            card.ability.extra.ourwakeXMult = card.ability.extra.ourwakeXMult - 1
            if card.ability.extra.ourwakeXMult <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = localize('k_nope_ex'),
                    colour = G.C.RED
                }
            else
                return {
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.ourwakeXMult}},
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker { -- Moth Joker
    key = 'moth',
    loc_txt = {
        name = 'Moth',
        text = {
            'At the end of the shop,',
            '{C:green}#1# in #2#{} chance to create',
            'a {C:purple}Legendary{C:attention} Joker'
        }
    },
    config = {extra = {mothProb = 50}},
    loc_vars = function(self,info_queue,card)
        return {vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.mothProb}}
    end,
    rarity = 3,
    atlas = 'BSMPJokers',
    pos = {x = 5, y = 1},
    cost = 10,
    calculate = function(self,card,context)
        if context.ending_shop then
            if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and (pseudorandom('moth') < G.GAME.probabilities.normal / card.ability.extra.mothProb) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function ()
                        local card = create_card('Joker',G.jokers,true,nil,nil,nil,nil,'moth')
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        G.GAME.joker_buffer = 0
                        return true
                    end
                )}))
            end
        end
    end
}

SMODS.Joker { -- Yoda Joker
    key = 'yodar',
    loc_txt = {
        name = 'Yoda',
        text = {
            'For every {C:diamonds}Diamond{} card scored,',
            '{C:green}#1# in #2#{} chance to add {C:money}$1{} of',
            '{C:attention}Sell Value{} to all Jokers'
        }
    },
    config = {extra = {yodaProb = 2}},
    loc_vars = function(self,info_queue,card)
        return {vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.yodaProb}}
    end,
    rarity = 2,
    atlas = 'BSMPJokers',
    pos = {x = 6, y = 1},
    cost = 8,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.after then
            changemade = false
            for k,v in ipairs(G.play.cards) do
                if v:is_suit('Diamonds',true) and (pseudorandom('yoda') < G.GAME.probabilities.normal / card.ability.extra.yodaProb) then
                    changemade = true
                    for k,v in ipairs(G.jokers.cards) do
                        if v.set_cost then
                            v.ability.extra_value = (v.ability.extra_value or 0) + 1
                            v:set_cost()
                        end
                    end
                end
            end
            if changemade then
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY 
                }
            end
        end
    end
}

--SMODS.Joker { --  Joker
    --key = 'A',
    --loc_txt = {
    --    name = 'A',
    --    text = ''
    --},
    --config = {extra = {}},
    --loc_vars = function(self,info_queue,card)
    --    return
    --end,
    --rarity = 4,
    --atlas = 'BSMPJokers',
    --pos = {x = 4, y = 1},
    --cost = 20,
    --calculate = function(self,card,context)
    --end
--}