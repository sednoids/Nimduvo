import Nimduvo/users
import std/[asyncdispatch, json]

let functionCall =  waitFor getUser(88)

echo $functionCall