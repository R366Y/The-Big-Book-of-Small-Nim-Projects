#[Bagels, by Al Sweigart al@inventwithpython.com
  A deductive logic game where you must guess a number based on clues.
  A version of this game is featured in the book, "Invent Your Own Computer Games with Python" https://nostarch.com/inventwithpython]#

import algorithm
import random
import seqUtils
import strformat
import strutils

randomize()
const NUM_DIGITS = 3
const MAX_GUESSES = 10

proc isNumeric(s: string): bool =
    for c in s:
        if not c.isDigit:
            return false
    return true

proc getSecretNum(): string =
    ## Returns a string made up of NUM_DIGITS unique random digits.
    var numbers = "0123456789".toSeq()
    shuffle(numbers)
    var secretNum = ""
    for i in 0..<NUM_DIGITS:
        secretNum = secretNum & char(numbers[i])
    return secretNum

proc getClues(guess: string, secretNum: string): string = 
    ## Returns a string with the pico, fermi, bagels clues for a guess 
    ## and secret number pair.
    
    if guess == secretNum:
        return "You got it!"

    var clues: seq[string] = @[]

    for i in 0..<guess.len:
        if guess[i] == secretNum[i]:
            clues.add("Fermi")
        elif guess[i] in secretNum:
            clues.add("Pico")
    if clues.len == 0:
        return "Bagels"
    else:
        sort(clues)
        return join(clues, " ")

proc main = 
    echo fmt"""
    Bagels, a deductive logic game.
 16. By Al Sweigart al@inventwithpython.com
 17. 
 18. I am thinking of a {NUM_DIGITS}-digit number with no repeated digits.
 19. Try to guess what it is. Here are some clues:
 20. When I say:    That means:
 21.   Pico         One digit is correct but in the wrong position.
 22.   Fermi        One digit is correct and in the right position.
 23.   Bagels       No digit is correct.
 24. 
 25. For example, if the secret number was 248 and your guess was 843, the
 26. clues would be Fermi Pico.
    """

    while true:
        let secretNum = getSecretNum()
        echo "I have thought up a number"
        echo fmt"You have {MAX_GUESSES} guesses to get it."

        var numGuesses = 1
        while numGuesses <= MAX_GUESSES:
            var guess = ""
            while guess.len != NUM_DIGITS or not guess.isNumeric:
                echo fmt"Guess #{numGuesses}"
                guess = readLine(stdin)

            let clues = getClues(guess, secretNum)
            echo clues
            numGuesses += 1

            if guess == secretNum:
                break
            if numGuesses > MAX_GUESSES:
                echo "You ran out of guesses"
                echo fmt"The answer was {secretNum}"

        echo "Do you want to play again? y/n"
        if not readLine(stdin).toLower().startsWith("y"):
            break
    echo "Thanks for playing"

main()