#[Birthday Paradox Simulation, by Al Sweigart al@inventwithpython.com
  Explore the surprising probabilities of the "Birthday Paradox".
  More info at https://en.wikipedia.org/wiki/Birthday_problem
  Tags: short, math, simulation]#

import std/enumerate
import math
import options
import random
import sequtils
import strformat
import strutils
import times

randomize()

proc isNumeric(s: string): bool =
    for c in s:
        if not c.isDigit:
            return false
    return true

proc getBirthdays(numberOfBirthdays: int): seq[DateTime] = 
    for i in 0..<numberOfBirthdays:
        # The year is unimportant for our simulation, as long as all
        # birthdays have the same year.
        let startOfTheYear = parse("2001-01-01", "yyyy-MM-dd")

        # Get a random day into the year
        let birthday = startOfTheYear + rand(0..364).days
        result.add(birthday)

proc getMatch(birthdays: seq[DateTime]): Option[DateTime] = 
    ## Returns the date object of a birthday that occurs more than once
    ## in the birthdays list.
    if birthdays.len == deduplicate(birthdays).len:
        return none(DateTime)

    # Compare each birthday to every other birthday
    for a, birthdayA in enumerate(birthdays):
        for b, birthdayB in enumerate(birthdays[a+1..^1]):
            if birthdayA == birthdayB:
                return some(birthdayA)


proc main = 
    echo """'Birthday Paradox, by Al Sweigart al@inventwithpython.com
    
     The birthday paradox shows us that in a group of N people, the odds
     that two of them have matching birthdays is surprisingly large.
     This program does a Monte Carlo simulation (that is, repeated random
     simulations) to explore this concept. 
     (It's not actually a paradox, it's just a surprising result.)
    """

    const MONTHS = ["Jan", "Frb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dev"]

    var numBdays:int
    while true:
        echo "How many birthdays shall I generate? (Max 100)"
        let response = readLine(stdin)
        if response.isNumeric and 0 < parseInt(response) and parseInt(response) <= 100:
            numBdays = parseInt(response)
            break
    echo ""

    # Generate and display birthdays
    echo fmt"Here are, {numBdays}, birthdays:"
    var birthdays = getBirthdays(numBdays)
    for i, birthday in enumerate(birthdays):
        if i != 0:
            stdout.write ", "
        let monthName = MONTHS[ord(birthday.month) - 1]
        let dateText = fmt"{monthName} {birthday.monthday}"
        stdout.write dateText
    echo ""
    echo ""

    # Determine if there are two birthdays that match
    let match = getMatch(birthdays)

    # display the result
    stdout.write "In this simulation, "
    if match.isSome :
        let monthName = MONTHS[ord(match.get().month) - 1]
        let dateText = fmt"{monthName} {match.get().monthday}"
        echo fmt"multiple people have a birthday on {dateText}"
    else:
        echo "there are not matching birthdays."
    echo ""

    # Run through 100,000 simulations
    echo fmt"Generating {numBdays} random birthdays 100,000 times..."
    echo "Press enter to begin..."
    discard stdin.readLine

    echo "Let's run another 100,000 simulations"
    var simMatch = 0
    for i in 1..100000:
        # report progress
        if i mod 10000 == 0:
            echo fmt"{i} simulations run..."
        birthdays = getBirthdays(numBdays)
        if getMatch(birthdays).isSome:
            simMatch += 1
    echo "100,000 simulations run"

    let probability = round(simMatch / 100000 * 100, 2)
    echo fmt"Out of 100,000 simulations of {numBdays} people, there was a"
    echo fmt"matching birthday in that group {simMatch} times. This means"
    echo fmt"that {numBdays} people have a {probability} % chance of"
    echo "having a matching birthday in their group."
    echo "That's probably more than you would think!"

main()