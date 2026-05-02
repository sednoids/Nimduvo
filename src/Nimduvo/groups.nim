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
    
        let 
            groupId = contentToJson["id"]
            groupName = contentToJson["name"]
            groupDescription = contentToJson["description"]
            ownerId = contentToJson["owner_id"]
            ownerUsername = contentToJson["owner_username"]
            access = contentToJson["access"]
            memberCount = contentToJson["member_count"]
            iconUrl = contentToJson["icon_url"]
            createdAt = contentToJson["created_at"]
            updatedAt = contentToJson["updated_at"]
            pendingIcon = contentToJson["pending_icon"]

        let response: OrderedTable[string, JsonNode] = {
            "group_id": groupId,
            "group_name": groupName,
            "group_description": groupDescription,
            "owner_id": ownerId,
            "owner_username": ownerUsername,
            "access": access,
            "member_count": memberCount,
            "icon_url": iconUrl,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "pending_icon": pendingIcon
        }.toOrderedTable()

        return %*response


    except KeyError as e:
        let error = {
            "error": e.msg}.toOrderedTable()
        return %*error