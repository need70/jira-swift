//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class Field: Mappable {
    
    var fieldId: String?
    var key: String?
    var name: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        fieldId     <- map["id"]
        key         <- map["key"]
        name        <- map["name"]
    }
}


/*
 
 
 clauseNames =     (
 creator
 );
 custom = 0;
 id = creator;
 key = creator;
 name = Creator;
 navigable = 1;
 orderable = 0;
 schema =     {
 system = creator;
 type = user;
 };
 searchable = 1;
 }
 */
