#[Caesar Cipher,original code by Al Sweigart al@inventwithpython.com
 2. The Caesar cipher is a shift cipher that uses addition and subtraction
 3. to encrypt and decrypt letters.
 4. More info at: https://en.wikipedia.org/wiki/Caesar_cipher
]#
import seqUtils
import strformat
import strutils

const SYMBOLS = "ABCDEFGHIJKLMNOPQRSTUWXYVZ"
type Mode = enum
    encrypt, decrypt

echo """The Caesar cipher encrypts letters by shifting them over by a
key number. For example, a key of 2 means the letter A is
encrypted into C, the letter B encrypted into D, and so on."""
echo ""

var mode: Mode
while true:
    echo "Do you want to (e)ncrypt or (d)ecrypt?"
    stdout.write("> ")
    let response = stdin.readLine.toLower
    if response.startsWith('e'):
        mode = encrypt
        break
    elif response.startsWith('d'):
        mode = decrypt
        break
    echo "Please enter the letter e or d"

var key: int
while true:
    let maxKey = len(SYMBOLS) - 1
    echo fmt"Please enter the key (0 to {maxKey}) to use"
    let response = stdin.readLine.toUpper
    if not all(response, proc(x:char):bool = x.isDigit):
        continue

    let iresponse = parseInt(response)
    if iresponse >= 0 and iresponse < len(SYMBOLS):
         key = iresponse
         break

# Let the user enter the message to encrypt/decrypt
echo(fmt"Enter the message to {mode}")
stdout.write("> ")
let message = stdin.readLine.toUpper

var translated = ""
for symbol in message:
    if symbol in SYMBOLS:
        # get the encrypted (or decrypted) number for this symbol
        var num = SYMBOLS.find(symbol)
        if mode == encrypt:
            num += key
        elif mode == decrypt:
            num -= key

        # Handle the wrap-around if num is larger than the length
        # of SYMBOLS or less than 0
        if num >= len(SYMBOLS):
            num -= len(SYMBOLS)
        elif num < 0:
            num += len(SYMBOLS)  

        translated = translated & SYMBOLS[num]
    else:
        # Just add the symbol without encrypting/decrypting
        translated = translated & symbol

echo translated

