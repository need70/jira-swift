//
//  BaseObject.swift
//    JIRA-Swift
//
//  Created by Andriy Kramar on 6/2/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol BaseObj {
    init(dict: [String : Any])
}

class ProjectObj: BaseObj {
    
    var projectName: String = ""
    var iconUrl: String = ""
    
    required init(dict: [String : Any]) {
        self.projectName = dict["name"] as! String
        
        if let avatarsDict: [String : String] = dict["avatarUrls"] as? [String : String] {
            self.iconUrl = avatarsDict["48x48"]!
        }
    }
    
}
