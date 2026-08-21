import std/[httpclient, json, strformat, tables, asyncdispatch]
import jsony

type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "users")

proc getUser*(userId: int): Future[JsonNode] {.async.} =
    ## Gets a user given a specific user ID.
    ## 
    ## ``userId``: The user ID.
    ## 
    ## ``username``: The username.
    ## 
    ## ``memberSince``: The account's creation date.
    ## 
    ## ``lastActive``: The last time the user was active.
    ## 
    ## ``bannerUrl``: The user's banner URL.
    ## 
    ## ``status``: The user's status.
    ## 
    ## ``bio``: The user's bio.
    ## 
    ## ``accentColour``: The user's accent colour.
    ## 
    ## ``avatar``: The user's avatar.
    ## 
    ## ``equippedItems``: The user's equipped items.
    ## 
    ## ``badges``: The user's badges.
    ## 
    ## ``friendCount``: The user's friend count.
    ## 
    ## ``placeCount``: The user's place count (games).
    ## 
    ## ``itemCount``: The user's item count.
    ## 
    ## ``allowJoins``: Whether the user allows joins off their profile.
    ## 
    ## ``isOwner``: Whether the account is the owner of Luduvo.
    var client = newAsyncHttpClient()
    defer: client.close()
    try:
        let content = await client.getContent(fmt"https://api.luduvo.com/users/{userId}/profile");
        let contentToJson = content.fromJson(JsonNode)
        
        return %*{
            "userId": contentToJson["user_id"], 
            "username": contentToJson["username"], 
            "memberSince": contentToJson["member_since"], 
            "last_active": contentToJson["last_active"], 
            "displayName": contentToJson["display_name"], 
            "bannerUrl": contentToJson["banner_url"],
            "status": contentToJson["status"],
            "bio": contentToJson["bio"],
            "accentColour": contentToJson["accent_color"],
            "avatar": contentToJson["avatar"],
            "equippedItems": contentToJson["equipped_items"],
            "badges": contentToJson["badges"],
            "friendCount": contentToJson["friend_count"],
            "placeCount": contentToJson["place_count"],
            "itemCount": contentToJson["item_count"],
            "allowJoins": contentToJson["allow_joins"],
            "isOwner": contentToJson["is_owner"]  }.toOrderedTable()

    except HttpRequestError as httpError:
        return %*{
            "error": httpError.msg.substr(0, 12)}.toOrderedTable()