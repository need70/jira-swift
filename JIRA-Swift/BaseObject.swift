//
//  BaseObject.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/2/17.
//  Copyright © 2017 home. All rights reserved.
//

class BaseObj {
    required init(dict: [String : Any]) { }
    
    func safeString(_ dict: [String : Any], _ key: String) -> String {        
        if let value = dict[key], value is String {
            return value as! String
        }
        return ""
    }
}

class IssueObj: BaseObj {
    
    var issueId: String = ""
    var key: String = ""
    var theDescription: String = ""
    var summary: String = ""
    var createdDate: String = ""
    var updatedDate: String = ""
    var reporter: UserObj?
    var assignee: UserObj?
    var project: ProjectObj?
    var type: IssueTypeObj?
    var priority: IssuePriorityObj?
    var status: IssueStatusObj?
    var resolution: IssueResolutionObj?
    
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        self.issueId = safeString(dict, "id")
        self.key = safeString(dict, "key")
        
        if let subDict = dict["fields"] as? [String : Any] {
            
            //common
            self.summary = safeString(subDict, "summary")
            self.theDescription = safeString(subDict, "description")
            
            //dates
            let created = Utils.formattedDateFrom(dateStr: safeString(subDict, "created"))
            let updated = Utils.formattedDateFrom(dateStr: safeString(subDict, "updated"))
            self.createdDate = created
            self.updatedDate = updated

            //project
            if let projDict = subDict["project"] as? [String : Any] {
                self.project = ProjectObj(dict: projDict)
            }
            
            //reporter
            if let repDict = subDict["reporter"] as? [String : Any] {
                self.reporter = UserObj(dict: repDict)
            }
            
            //assignee
            if let aDict = subDict["assignee"] as? [String : Any] {
                self.assignee = UserObj(dict: aDict)
            } 
            
            //issuetype
            if let dict = subDict["issuetype"] as? [String : Any] {
                self.type = IssueTypeObj(dict: dict)
            }
            
            //priority
            if let dict = subDict["priority"] as? [String : Any] {
                self.priority = IssuePriorityObj(dict: dict)
            }
            
            //status
            if let dict = subDict["status"] as? [String : Any] {
                self.status = IssueStatusObj(dict: dict)
            }
            
            //resolution
            if let dict = subDict["resolution"] as? [String : Any] {
                self.resolution = IssueResolutionObj(dict: dict)
            }
        }
    }
}

class ProjectObj: BaseObj {
    
    var name: String = ""
    var key: String = ""
    var iconUrl: String = ""
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)

        self.name = safeString(dict, "name")
        self.key = safeString(dict, "key")
        
        if let avatarsDict = dict["avatarUrls"] as? [String : String] {
            self.iconUrl = safeString(avatarsDict, "48x48")
        }
    }
}

class UserObj: BaseObj {
    
    var displayName: String = ""
    var emailAddress: String = ""
    var name: String = ""
    var avatarUrl: String = ""
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        self.displayName = safeString(dict, "displayName")
        self.emailAddress = safeString(dict, "emailAddress")
        self.name = safeString(dict, "name")
        
        if let subDict = dict["avatarUrls"] as? [String : String] {
            self.avatarUrl = safeString(subDict, "48x48")
        }
    }
}

class IssueTypeObj: BaseObj {
    
    var name: String = ""
    var iconUrl: String = ""
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        self.name = safeString(dict, "name")
        self.iconUrl = safeString(dict, "iconUrl")
    }
}

class IssuePriorityObj: BaseObj {
    
    var name: String = ""
    var iconUrl: String = ""
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        self.name = safeString(dict, "name")
        self.iconUrl = safeString(dict, "iconUrl")
    }
}

class IssueStatusObj: BaseObj {
    
    var name: String = ""
    var iconUrl: String = ""
    var colorName: String = ""
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        self.name = safeString(dict, "name")
        self.iconUrl = safeString(dict, "iconUrl")
        
        if let subDict = dict["statusCategory"] as? [String : Any] {
            self.colorName = safeString(subDict, "colorName")
        }
    }
    
    func getStatusColor() -> UIColor {
        
        switch self.colorName {
        case "green":
            return .green
        case "blue-gray":
            return .blue
        default:
            return .gray
        }
    }
}

class IssueResolutionObj: BaseObj {
    
    var name: String = ""
    
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        self.name = safeString(dict, "name")
    }
}


