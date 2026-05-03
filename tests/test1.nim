import Nimduvo/[users, groups]
import std/[asyncdispatch, json]

let functionCallUser* =  waitFor getUser(88)

# echo $functionCallUser

let secondFunctionCallUser* =  waitFor getUser(40394)

# echo $secondFunctionCallUser

let firstFunctionCallGroup* = waitFor getGroup(88)

# echo $firstFunctionCallGroup

let secondFunctionCallGroup* = waitFor getGroup(980302038)

# echo $secondFunctionCallGroup
