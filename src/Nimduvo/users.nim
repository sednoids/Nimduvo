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
        
        return %*{
            "user_id": contentToJson["user_id"], 
            "username": contentToJson["username"], 
            "member_since": contentToJson["member_since"], 
            "last_active": contentToJson["last_active"], 
            "displayName": contentToJson["display_name"], 
            "banner_url": contentToJson["banner_url"],
            "status": contentToJson["status"],
            "bio": contentToJson["bio"],
            "accent_colour": contentToJson["accent_color"],
            "avatar": contentToJson["avatar"],
            "equipped_items": contentToJson["equipped_items"],
            "badges": contentToJson["badges"],
            "friend_count": contentToJson["friend_count"],
            "place_count": contentToJson["place_count"],
            "item_count": contentToJson["item_count"],
            "allow_joins": contentToJson["allow_joins"],
            "is_owner": contentToJson["is_owner"]  }.toOrderedTable()

    except HttpRequestError as httpError:
        return %*{
            "error": httpError.msg.substr(0, 12)}.toOrderedTable()