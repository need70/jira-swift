//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class TempoTeam: Mappable {
    
    var teamId: Int?
    var lead: String?
    var name: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        teamId     <- map["id"]
        lead       <- map["lead"]
        name       <- map["name"]
    }
}

/*
 {
 id = 1;
 lead = "<null>";
 leadUser = "<null>";
 mission = "<null>";
 name = "Default Tempo Team";
 program = "<null>";
 summary = "<null>";
 teamLinks = "<null>";
 teamProgram = "<null>";
 }
 */
