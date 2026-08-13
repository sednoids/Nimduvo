import std/[httpclient, json, strformat, tables, asyncdispatch]
import jsony

type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "groups")

proc getGroup*(groupId: int): Future[JsonNode] {.async.} =
    ## Gets a Luduvo group given their group ID.
    var client = newAsyncHttpClient()
    defer: client.close()
    try:
        let 
            content = await client.getContent(fmt"https://api.luduvo.com/groups/{groupId}")
            contentToJson = content.fromJson(JsonNode)

        return %*{
            "group_id": contentToJson["id"],
            "group_name": contentToJson["name"],
            "group_description": contentToJson["description"],
            "owner_id": contentToJson["owner_id"],
            "owner_username": contentToJson["owner_username"],
            "access": contentToJson["access"],
            "member_count": contentToJson["member_count"],
            "icon_url": contentToJson["icon_url"],
            "created_at": contentToJson["created_at"],
            "updated_at": contentToJson["updated_at"],
            "pending_icon": contentToJson["pending_icon"]}.toOrderedTable()

    except HttpRequestError as httpError:
        return %*{
            "error": httpError.msg.substr(0, 12)}.toOrderedTable()