import std/[httpclient, json, strformat, tables, asyncdispatch]

type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "users")

proc getUser*(userId: int): Future[string] {.async.} =
    ## Gets a user given a specific user ID.
    var client = newHttpClient()
    try:
        let content = client.getContent(fmt"https://api.luduvo.com/users/{userId}/profile");
        let contentToJson = parseJson(content)

        let
            userId = contentToJson["user_id"]
            username = contentToJson["username"]
            memberSince = contentToJson["member_since"]
            lastActive = contentToJson["last_active"]
            displayName = contentToJson["display_name"]
            banner_url = contentToJson["banner_url"]
            status = contentToJson["status"]
            bio = contentToJson["bio"]
            accentColour = contentToJson["accent_color"]
        
        let res = {
            "user_id": userId, 
            "user_name": username, 
            "member_since": memberSince, 
            "last_active": lastActive, 
            "displayName": display_name, 
            "banner_url": bannerUrl,
            "status": status,
            "bio": bio,
            "accent_colour": accentColour}.toTable()

        for k, v in pairs(res):
            echo fmt"{k}: {v}"
        
    except KeyError as e:
        echo e.msg
    finally:
      client.close()