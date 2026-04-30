# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.



import unittest
# import std/json
# 
# import Nimduvo
# test "can return content":
#  check getUser(88) is st
import Nimduvo/users
import std/[asyncdispatch, tables]

let functionCall =  waitFor getUser(88)

echo functionCall