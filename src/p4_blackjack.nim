#["""Blackjack, by Al Sweigart al@inventwithpython.com
    The classic card game also known as 21. (This version doesn't have
    splitting or insurance.)
    More info at: https://en.wikipedia.org/wiki/Blackjack]#

import std/enumerate
import sequtils
import strformat
import strutils
import random

randomize()

const HEARTS = "\u2665"
const DIAMONDS = "\u2666"
const SPADES = "\u2660"
const CLUBS = "\u2663"
const BACKSIDE = "backside"


var money = 5000

proc getBet(maxBet: int): int =
    ## Ask the player how much they want to bet for this round
    while true:
        echo fmt"How much do you bet? (1-{maxBet}, or QUIT)"
        let bet = stdin.readLine.toUpper.strip
        if bet == "QUIT":
            echo "Thanks for playing!"
            quit()
        if any(bet, proc(x:char):bool = not x.isDigit):
            # the player didn't enter a number
            continue

        let ibet = bet.parseInt
        if 1 <= ibet and ibet <= maxBet:
            return ibet


proc getDeck(): auto = 
    ## Return a list of (rank, suit) tuples for all 52 cards
    var deck = newSeq[(string, string)](52)
    var index = 0
    for suit in [HEARTS, DIAMONDS, SPADES, CLUBS]:
        for rank in 2..10:
            deck[index] = ($rank, suit)
            index += 1
        for rank in ["J", "Q", "K", "A"]:
            deck[index] = (rank, suit)
            index += 1
    assert index == 52
    shuffle(deck)
    return deck


proc displayCards(cards: openArray[(string, string)]) =
    ## Display all the cards in the cards list
    var rows = ["", "", "", ""]

    for i, card in enumerate(cards):
        rows[0] &= " ___  "
        if card[1] == BACKSIDE:
            # Print card's back
            rows[1] &= "|## | "
            rows[2] &= "|###| "
            rows[3] &= "|_##| "
        else:
            # print the card's front
            let 
                rank = card[0] 
                suit = card[1]
            rows[1] &= fmt"|{rank.alignLeft(2)} | "
            rows[2] &= fmt"| {suit} | "
            rows[3] &= fmt"|_{rank.align(2)}| "
    for row in rows:
        echo row


proc getHandValue(cards: openArray[(string, string)]): int = 
    ## Returns the value of the cards. Face cards are worth 10, 
    ## aces are worth 11 or 1 
    ## (this function picks the most suitable ace value)
    var value = 0
    var numberOfAces = 0

    # Add the value for the non-ace cards
    for card in cards: 
        let rank = card[0]
        if rank == "A":
            numberOfAces += 1
        elif rank in ["K", "Q", "J"]:
            value += 10
        else:
            value += parseInt(rank)
    
    value += numberOfAces
    for i in 0..<numberOfAces:
        # if another 10 can be added without busting, do so
        if value + 10 <= 21:
            value += 10
    return value


proc displayHands(playerHand: openArray[(string, string)], 
                  dealerHand: openArray[(string, string)], 
                  showDealerHand: bool) = 
    ## Show the player's and dealer's cards. Hide the dealer's first
    ## card if showDealerHand is false
    echo ""
    if showDealerHand:
        echo "DEALER: " & $getHandValue(dealerHand)
        displayCards(dealerHand)
    else:
        echo "DEALER: ???"
        # hide the dealer's first card
        displayCards(concat(@[("", BACKSIDE)], dealerHand[1..^1]))
    echo "PLAYER: " & $getHandValue(playerHand)
    displayCards(playerHand)


proc getMove(playerHand: openArray[(string, string)], money: int): string = 
    ## Asks the player for their move, and returns 'H' for hit,
    ## 'S' for stand, and 'D' for double down
    while true:
        var moves = @["(H)it", "(S)tand"]
        
        # The player can double down on their first move,
        # which we can tell because they'll have exactly
        # two cards
        if playerHand.len == 2 and money > 0:
            moves.add("(D)ouble down")

        let movePrompt = join(moves, ", ") & "> "
        stdout.write(movePrompt)
        let move = stdin.readLine
        if move in ["H", "S"]:
            return move
        if move == "D" and "(D)ouble down" in moves:
            return move


proc main = 
    echo """Blackjack, by Al Sweigart al@inventwithpython.com
  
      Rules:
        Try to get as close to 21 without going over.
        Kings, Queens, and Jacks are worth 10 points.
        Aces are worth 1 or 11 points.
        Cards 2 through 10 are worth their face value.
        (H)it to take another card.
        (S)tand to stop taking cards.
        On your first play, you can (D)ouble down to increase your bet
        but must hit exactly one more time before standing.
        In case of a tie, the bet is returned to the player.
        The dealer stops hitting at 17.
    """
    # main game loop
    while true:
        if money <= 0:
            echo "You are broke!"
            echo "Good thing you weren't playing with real money."
            echo "Thanks for playing"
            quit()

        # let the player enter their bet for this round
        echo "Money:" & $money
        var bet = getBet(money)

        # Give the dealer and player two cards from the deck each
        var deck = getDeck()
        var dealerHand = @[deck.pop, deck.pop]
        var playerHand = @[deck.pop, deck.pop]

        echo "Bet: " & $bet
        #Keep looping until player stands or busts
        while true:
            displayHands(playerHand, dealerHand, false)
            echo ""

            # Check if player has bust
            if getHandValue(playerHand) > 21:
                break
            
            let move = getMove(playerHand, money - bet)
            if move == "D":
                # player is doubling down, they can increase their bet
                let additionalBet = getBet(min(bet, money - bet))
                bet += additionalBet
                echo fmt"Bet increased to {bet}"
                echo "Bet: " & $bet

            if move in ["H", "D"]:
                # Hit doubling down takes another card
                let newCard = deck.pop
                let
                    rank = newCard[0]
                    suit = newCard[1]
                echo fmt"You drew a {rank} of {suit}"
                playerHand.add(newCard)

                if getHandValue(playerHand) > 21:
                    # The player has busted
                    continue
            
            if move in ["S", "D"]:
                # Stand/ doubling down stops the player's turn
                break
        
        # Handle the dealer's actions
        if getHandValue(playerHand) <= 21:
            while getHandValue(dealerHand) < 17:
                # the dealer hits
                echo "Dealer hits..."
                dealerHand.add(deck.pop)
                displayHands(playerHand, dealerHand, false)

                if getHandValue(dealerHand) > 21:
                    break
                echo "Press enter to continue..."
                discard stdin.readChar
                echo "\n\n"

        # show the final hands
        displayHands(playerHand, dealerHand, true)

        let playerValue = getHandValue(playerHand)
        let dealerValue = getHandValue(dealerHand)
        # handle whether the player won, lost, or tied
        if dealerValue > 21:
            echo fmt"Dealer busts! You win {bet}"
            money += bet
        elif playerValue > 21 or playerValue < dealerValue:
            echo "You lost"
            money -= bet
        elif playerValue > dealerValue:
            echo fmt"You won {bet}"
            money += bet
        elif playerValue == dealerValue:
            echo "It's a tie, the bet is returned to you"
        echo "Press enter to continue.."
        discard stdin.readChar
        echo "\n\n"


main()