import std/[httpclient, json, strformat]

type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "users")


var client = newHttpClient()

proc getUser*(userId: int): string =
    ## Gets a user given a specific user ID.
    try:
        let content = client.getContent(fmt"https://api.luduvo.com/users/{userId}/profile");
        let contentToJson = parseJson(content)

        let
            userId = contentToJson["user_id"]
            username = contentToJson["username"]
            memberSince = contentToJson["member_since"]
            lastActive = contentToJson["last_active"]
            displayName = contentToJson["display_name"]
            bannerUrl = contentToJson["avatar"]["banner_url"]
            status = contentToJson["status"]
            bio = contentToJson["bio"]
            accentColour = contentToJson["avatar"]["accent_color"]
        
        echo userId, username, memberSince, lastActive, displayName, bannerUrl, status, bio, accentColour
    except KeyError:
        # this is for debug
        echo "Profile not found."
    finally:
      client.close()