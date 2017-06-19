//
//  Attachment.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import ObjectMapper

class TimeTracking: Mappable {
    
    var originalEstimate: String?
    var remainingEstimate: String?
    var timeSpent: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        originalEstimate   <- map["originalEstimate"]
        remainingEstimate  <- map["remainingEstimate"]
        timeSpent          <- map["timeSpent"]
    }
}

