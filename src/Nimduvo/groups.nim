import std/[httpclient, json, strformat, tables, asyncdispatch]
import jsony

type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "groups")

proc getGroup*(groupId: int): Future[JsonNode] {.async.} =
    ## Gets a Luduvo group given their group ID.
    ## 
    ## ``groupId``: The group ID. 
    ## 
    ## ``groupName``: The group name.
    ## 
    ## ``groupDescription``: The group description.
    ## 
    ## ``ownerId``: The group owner's ID.
    ## 
    ## ``ownerUsername``: The username of the owner.
    ## 
    ## ``access``: The type of access the group has. There are **two** types of access: **public** and **invitation**.
    ## 
    ## ``memberCount``: The group's member count.
    ## 
    ## ``iconUrl``: The icon URL.
    ## 
    ## ``createdAt``: The group's creation date.
    ## 
    ## ``updateAt``: When last the group was updated.
    ## 
    ## ``pendingIcon``: The group's pending icon.
    var client = newAsyncHttpClient()
    defer: client.close()
    try:
        let 
            content = await client.getContent(fmt"https://api.luduvo.com/groups/{groupId}")
            contentToJson = content.fromJson(JsonNode)

        return %*{
            "groupId": contentToJson["id"],
            "groupName": contentToJson["name"],
            "groupDescription": contentToJson["description"],
            "ownerId": contentToJson["owner_id"],
            "ownerUsername": contentToJson["owner_username"],
            "access": contentToJson["access"],
            "memberCount": contentToJson["member_count"],
            "iconUrl": contentToJson["icon_url"],
            "createdAt": contentToJson["created_at"],
            "updatedAt": contentToJson["updated_at"],
            "pendingIcon": contentToJson["pending_icon"]}.toOrderedTable()

    except HttpRequestError as httpError:
        return %*{
            "error": httpError.msg.substr(0, 12)}.toOrderedTable()