#[Deep Cave, original code by Al Sweigart al@inventwithpython.com
 2. An animation of a deep cave that goes forever into the earth.
]#

import math
import os
import random
import strutils

randomize()

const WIDTH = 70
const PAUSE_AMOUNT = 50

echo "Deep cave"
echo "Press ctrl-c to stop"

sleep(1500)



proc randInt(min: int, max: int): int =
    return min + floor((max - min).toFloat * rand(1.0)).toInt

proc main =
    var leftWidth = 20
    let gapWidth = 10
    while true:
        # Display the tunnel segment
        let rightWidth = WIDTH - gapWidth - leftWidth
        echo '#'.repeat(leftWidth) & ' '.repeat(gapWidth) & '#'.repeat(rightWidth)

        sleep(PAUSE_AMOUNT)

        # Adjust the left side width
        let diceRoll = randInt(1, 6)
        if diceRoll == 1 and leftWidth > 1:
            leftWidth -= 1
        elif diceRoll == 2 and leftWidth + gapWidth < WIDTH - 1:
            leftWidth += 1
        else:
            discard

main()