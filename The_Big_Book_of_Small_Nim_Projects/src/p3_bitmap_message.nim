import std/enumerate
import strutils

var bitmap = """
....................................................................
   **************   *  *** **  *      ******************************
  ********************* ** ** *  * ****************************** *
 **      *****************       ******************************
          *************          **  * **** ** ************** *
           *********            *******   **************** * *
            ********           ***************************  *
   *        * **** ***         *************** ******  ** *
               ****  *         ***************   *** ***  *
                 ******         *************    **   **  *
                 ********        *************    *  ** ***
                   ********         ********          * *** ****
                   *********         ******  *        **** ** * **
                   *********         ****** * *           *** *   *
                     ******          ***** **             *****   *
                     *****            **** *            ********
                    *****             ****              *********
                    ****              **                 *******   *
                    ***                                       *    *
                    **     *                    *
...................................................................."""

echo "Bytmap message, original code by Al Sweigart al@inventwithpython.com"
echo "Enter the message to display with the bitmap"
var message = stdin.readLine
if message == "":
    quit()

# Loop for each line in the bitmap
for line in bitmap.splitLines:
    for i, bit in enumerate(line):
        if bit == ' ':
            stdout.write(' ')
        else:
            stdout.write(message[i mod message.len])
    echo ""