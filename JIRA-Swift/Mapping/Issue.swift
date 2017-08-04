//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

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
    var watchCount: Int?
    var isWatching: Bool?
    var timeTracking: TimeTracking?
    var comments: [Comment]?
    var attachments: [Attachment]?
    
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
        watchCount      <- map["fields.watches.watchCount"]
        isWatching      <- map["fields.watches.isWatching"]
        timeTracking    <- map["fields.timetracking"]
        comments        <- map["fields.comment.comments"]
        attachments     <- map["fields.attachment"]
    }
}

extension Issue {
    
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

//MARK: - IssueType

class IssueType: Mappable {
    
    var typeId: String?
    var name: String?
    var iconUrl: String?
    var isSubtask: Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        typeId    <- map["id"]
        name      <- map["name"]
        iconUrl   <- map["iconUrl"]
        isSubtask <- map["subtask"]
    }
}

//MARK: - IssuePriority

class IssuePriority: Mappable {
    
    var priorityId: String?
    var name: String?
    var iconUrl: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        priorityId  <- map["id"]
        name        <- map["name"]
        iconUrl     <- map["iconUrl"]
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
}

extension IssueStatus {
    
    func getStatusColor() -> UIColor {
        
        switch colorName {
        case "green": return .green
        case "blue-gray": return .blue
        case "yellow" : return .orange
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

