//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var displayName: String?
    var emailAddress: String?
    var name: String!
    var avatarUrl: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        displayName     <- map["displayName"]
        emailAddress    <- map["emailAddress"]
        name            <- map["name"]
        avatarUrl       <- map["avatarUrls.48x48"]
    }
}
