import Nimduvo/users
import std/[asyncdispatch, json]

let functionCall =  waitFor getUser(40394)

echo $functionCall