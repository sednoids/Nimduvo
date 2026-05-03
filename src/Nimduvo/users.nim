import std/[httpclient, json, strformat, tables, asyncdispatch]
import jsony

type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "users")

# note to self: find out how to deal with invalid user ids
proc getUser*(userId: int): Future[JsonNode] {.async.} =
    ## Gets a user given a specific user ID.
    var client = newAsyncHttpClient()
    defer: client.close()
    try:
        let content = await client.getContent(fmt"https://api.luduvo.com/users/{userId}/profile");
        let contentToJson = content.fromJson(JsonNode)

        let
            userId = contentToJson["user_id"]
            username = contentToJson["username"]
            memberSince = contentToJson["member_since"]
            lastActive = contentToJson["last_active"]
            displayName = contentToJson["display_name"]
            avatar = contentToJson["avatar"]
            banner_url = contentToJson["banner_url"]
            status = contentToJson["status"]
            bio = contentToJson["bio"]
            accentColour = contentToJson["accent_color"]
            equippedItems = contentToJson["equippedItems"]
            badges = contentToJson["badges"]
            friendCount = contentToJson["friend_count"]
            placeCount = contentToJson["place_count"]
            itemCount = contentToJson["item_count"]
            allowJoins = contentToJson["allow_joins"]
            isOwner = contentToJson["is_owner"]            
        
        return %*{
            "user_id": userId, 
            "username": username, 
            "member_since": memberSince, 
            "last_active": lastActive, 
            "displayName": displayName, 
            "banner_url": banner_url,
            "status": status,
            "bio": bio,
            "accent_colour": accentColour,
            "avatar": avatar,
            "equipped_items": equippedItems,
            "badges": badges,
            "friend_count": friendCount,
            "place_count": placeCount,
            "item_count": itemCount,
            "allow_joins": allowJoins,
            "is_owner": isOwner}.toOrderedTable()

    except HttpRequestError as httpError:
        return %*{
            "error": httpError.msg.substr(0, 12)}.toOrderedTable()