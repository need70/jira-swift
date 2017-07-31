//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class Project: Mappable {
    
    var projectId: String?
    var name: String?
    var key: String?
    var iconUrl: String?
    var issueTypes: [IssueType]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        projectId  <- map["id"]
        name       <- map["name"]
        key        <- map["key"]
        iconUrl    <- map["avatarUrls.48x48"]
        issueTypes <- map["issuetypes"]
        
    }
}
