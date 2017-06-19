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
    
    var name: String?
    var key: String?
    var iconUrl: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name       <- map["name"]
        key        <- map["key"]
        iconUrl    <- map["avatarUrls.48x48"]
    }
}
