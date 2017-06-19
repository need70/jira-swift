//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
    
    var body: String?
    var createdDate: String?
    var updatedDate: String?
    var author: User?
    var updateAuthor: User?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        body            <- map["body"]
        createdDate     <- map["created"]
        updatedDate     <- map["updated"]
        author          <- map["author"]
        updateAuthor    <- map["updateAuthor"]
    }
    
    func formattedCreated() -> String {
        if let created = createdDate {
            return Utils.formattedDateFrom(dateStr: created)
        }
        return ""
    }
}

