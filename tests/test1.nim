import Nimduvo/users
import std/[asyncdispatch, json]

let functionCall =  waitFor getUser(88)

echo $functionCall

let secondFunctionCall =  waitFor getUser(40394)

echo $secondFunctionCall