//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class Board: Mappable {
    
    var boardId: Int?
    var name: String!
    var type: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        boardId     <- map["id"]
        name        <- map["name"]
        type        <- map["type"]
    }
}

class BoardColumn: Mappable {
    
    var name: String?
    var statuses: [Int] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name        <- map["name"]
        statuses    <- map["statuses.id"]
    }
}

/*
 {
 "name": "Backlog",
 "statuses": [
 {
 "id": "10300",
 "self": "https://onix-systems.atlassian.net/rest/api/2/status/10300"
 }
 ]
 },
 */
