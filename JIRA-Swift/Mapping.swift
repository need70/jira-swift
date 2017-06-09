//
//  BaseObj.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/9/17.
//  Copyright © 2017 home. All rights reserved.
//

import ObjectMapper


//MARK: - Issue

class Issue: Mappable {
    
    var issueId: String?
    var key: String?
    var descript: String?
    var summary: String?
    var createdDate: String?
    var updatedDate: String?
    var reporter: User?
    var assignee: User?
    var project: Project?
    var type: IssueType?
    var priority: IssuePriority?
    var status: IssueStatus?
    var resolution: IssueResolution?
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        issueId         <- map["id"]
        key             <- map["key"]
        descript        <- map["fields.description"]
        summary         <- map["fields.summary"]
        createdDate     <- map["fields.created"]
        updatedDate     <- map["fields.updated"]
        assignee        <- map["fields.assignee"]
        reporter        <- map["fields.reporter"]
        project         <- map["fields.project"]
        type            <- map["fields.issuetype"]
        priority        <- map["fields.priority"]
        status          <- map["fields.status"]
        resolution      <- map["fields.resolution"]
    }
    
    func formattedCreated() -> String {
        if let created = createdDate {
            return Utils.formattedDateFrom(dateStr: created)
        }
        return ""
    }
    
    func formattedUpdated() -> String {
        if let updated = updatedDate {
            return Utils.formattedDateFrom(dateStr: updated)
        }
        return ""
    }
}

//MARK: - User

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

//MARK: - Project

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

//MARK: - IssueType

class IssueType: Mappable {
    
    var name: String?
    var iconUrl: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name      <- map["name"]
        iconUrl   <- map["iconUrl"]
    }
}

//MARK: - IssuePriority

class IssuePriority: Mappable {
    
    var name: String?
    var iconUrl: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name      <- map["name"]
        iconUrl   <- map["iconUrl"]
    }
}

//MARK: - IssueStatus

class IssueStatus: Mappable {
    
    var name: String?
    var iconUrl: String?
    var colorName: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name       <- map["name"]
        iconUrl    <- map["iconUrl"]
        colorName  <- map["statusCategory.colorName"]
    }
    
    func getStatusColor() -> UIColor {
        
        switch colorName {
            case "green": return .green
            case "blue-gray": return .blue
            default: return .gray
        }
    }
}

//MARK: - IssueResolution

class IssueResolution: Mappable {
    
    var name: String?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name     <- map["name"]
    }
}


