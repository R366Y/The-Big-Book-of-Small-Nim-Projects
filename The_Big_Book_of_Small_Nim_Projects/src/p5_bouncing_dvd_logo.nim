import illwill
import math
import os
import random

randomize()

type Direction = enum
    up_right, up_left, down_right, down_left

type Sprite = ref object
    color: ForegroundColor
    x: int
    y: int
    dir: Direction

const NUMBER_OF_LOGOS = 5
const PAUSE_AMOUNT = 30

const COLORS = [fgRed, fgGreen, fgYellow, fgBlue, fgMagenta, fgCyan, fgWhite]
const DIRECTIONS = [up_right, up_left, down_right, down_left]

proc randInt(min: int, max: int): int =
    return min + floor((max - min).toFloat * rand(1.0)).toInt

proc main =

    let WIDTH = terminalWidth()
    let HEIGHT = terminalHeight()

    var logos: seq[Sprite]
    for i in 0..<NUMBER_OF_LOGOS:
        logos.add(
            Sprite(color: sample(COLORS),
             x: randInt(3, WIDTH - 4),
             y: randInt(3, HEIGHT - 4),
             dir: sample(DIRECTIONS)
            )
        )

    proc exitProc() {.noconv.} =
        illwillDeinit()
        showCursor()
        quit(0)

    illwillInit(fullscreen = true)
    setControlCHook(exitProc)
    hideCursor()

    var tb = newTerminalBuffer(WIDTH, HEIGHT)

    var cornerBounces = 0
    while true:
        tb.write(0, 0, fgWhite, styleBright, "Draw with left/right/middle click; hold Ctrl for brigher colours")
        tb.write(0, 1, "Press Q or Ctrl-C to quit")
        var key = getKey()
        case key
        of Key.None: discard
        of Key.Escape, Key.Q: exitProc()
        else:
            echo key
            discard

        for logo in logos:
            # erase logo
            tb.write(logo.x, logo.y, logo.color, styleBright, "   ")
            let originalDirection = logo.dir

            # see if logo bounces off the corners
            if logo.x <= 3 and logo.y <= 0:
                logo.dir = down_right
                cornerBounces += 1
            elif logo.x <= 3 and logo.y >= HEIGHT - 1:
                logo.dir = up_right
                cornerBounces += 1
            elif logo.x >= WIDTH - 3 and logo.y <= 0:
                logo.dir = down_left
                cornerBounces += 1
            elif logo.x >= WIDTH - 3 and logo.y >= HEIGHT - 1:
                logo.dir = up_left
                cornerBounces += 1

            # see if the logo bounces off the left edge
            elif logo.x <= 3 and logo.dir == up_left:
                logo.dir = up_right
            elif logo.x <= 3 and logo.dir == down_left:
                logo.dir = down_right

            # see if the logo bounces off the right edge
            elif logo.x >= WIDTH - 3 and logo.dir == up_right:
                logo.dir = up_left
            elif logo.x >= WIDTH - 3 and logo.dir == down_right:
                logo.dir = down_left

            # see if the logo bounces off the top edge
            elif logo.y <= 0 and logo.dir == up_left:
                logo.dir = down_left
            elif logo.y <= 0 and logo.dir == up_right:
                logo.dir = down_right

            # see if the logo bounces off the bottom edge
            elif logo.y >= HEIGHT - 1 and logo.dir == down_left:
                logo.dir = up_left
            elif logo.y >= HEIGHT - 1 and logo.dir == down_right:
                logo.dir = up_right

            if logo.dir != originalDirection:
                logo.color = sample(COLORS)

            case logo.dir:
            of up_right:
                logo.x += 2
                logo.y -= 1
            of up_left:
                logo.x -= 2
                logo.y -= 1
            of down_right:
                logo.x += 2
                logo.y += 1
            of down_left:
                logo.x -= 2
                logo.y += 1

        tb.write(WIDTH - 20, 1, fgWhite, styleBright, "Corner bounces: " & $cornerBounces)

        for logo in logos:
            tb.write(logo.x, logo.y, logo.color, styleBright, "DVD")
        tb.display()
        sleep(PAUSE_AMOUNT)

main()
