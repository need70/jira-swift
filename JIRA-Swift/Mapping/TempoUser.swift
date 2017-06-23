//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class TempoUser: Mappable {
    
    var member: TempoUserMember?
    var memberBean: TempoUserMember?
    var membership: TempoUserMembership?
    var membershipBean: TempoUserMembership?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        member          <- map["member"]
        memberBean      <- map["memberBean"]
        membership      <- map["membership"]
        membershipBean  <- map["membershipBean"]
    }
}

class TempoUserMember: Mappable {
    
    var teamMemberId: Int?
    var avatar: String?
    var name: String?
    var displayName: String?
    var type: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        teamMemberId     <- map["teamMemberId"]
        avatar           <- map["avatar.48x48"]
        name             <- map["name"]
        displayName      <- map["displayname"]
        type             <- map["type"]
    }
}

class TempoUserMembership: Mappable {
    
    var _id: Int?
    var role: String?
    var dateFrom: String?
    var dateTo: String?
    var availability: String?
    var status: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        _id             <- map["id"]
        role            <- map["role.name"]
        dateFrom        <- map["dateFrom"]
        dateTo          <- map["dateTo"]
        availability    <- map["availability"]
        status          <- map["status"]
    }
}

/*
 {
 {
 "id": 146,
 "member": {
 "teamMemberId": 146,
 "name": "eugene.ghostishev",
 "avatar": {
 "48x48": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=48&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3FownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue",
 "24x24": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=24&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3Fsize%3Dsmall%26ownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue",
 "16x16": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=16&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3Fsize%3Dxsmall%26ownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue",
 "32x32": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=32&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3Fsize%3Dmedium%26ownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue"
 },
 "activeInJira": true,
 "message": null,
 "key": "eugene.ghostishev",
 "displayname": "Eugene Ghostishev",
 "type": "USER"
 },
 "memberBean": {
 "teamMemberId": 146,
 "name": "eugene.ghostishev",
 "avatar": {
 "48x48": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=48&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3FownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue",
 "24x24": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=24&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3Fsize%3Dsmall%26ownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue",
 "16x16": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=16&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3Fsize%3Dxsmall%26ownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue",
 "32x32": "https://avatar-cdn.atlassian.com/fff58de2771e593bf2236f3495b08340?s=32&d=https%3A%2F%2Fonix-systems.atlassian.net%2Fsecure%2Fuseravatar%3Fsize%3Dmedium%26ownerId%3Deugene.ghostishev%26avatarId%3D12801%26noRedirect%3Dtrue"
 },
 "activeInJira": true,
 "message": null,
 "key": "eugene.ghostishev",
 "displayname": "Eugene Ghostishev",
 "type": "USER"
 },
 "membership": {
 "id": 147,
 "role": {
 "id": 4,
 "name": "Developer",
 "default": false
 },
 "dateFrom": "14/Dec/16",
 "dateTo": "31/Jan/17",
 "dateFromANSI": "2016-12-14",
 "dateToANSI": "2017-01-31",
 "availability": "100",
 "teamMemberId": 146,
 "teamId": 13,
 "status": "past"
 },
 "membershipBean": {
 "id": 147,
 "role": {
 "id": 4,
 "name": "Developer",
 "default": false
 },
 "dateFrom": "14/Dec/16",
 "dateTo": "31/Jan/17",
 "dateFromANSI": "2016-12-14",
 "dateToANSI": "2017-01-31",
 "availability": "100",
 "teamMemberId": 146,
 "teamId": 13,
 "status": "past"
 },
 "groupForUser": null,
 "showDeactivate": false
 },
 */
