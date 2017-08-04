//
//  Issue.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class Worklog: Mappable {
    
    var worklogId: Int?
    var timeSpentSeconds: Int?
    var dateStarted: String?
    var comment: String?
    var author: User?
    var issue: Issue?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        worklogId           <- map["id"]
        timeSpentSeconds    <- map["timeSpentSeconds"]
        dateStarted         <- map["dateStarted"]
        comment             <- map["comment"]
        author              <- map["author"]
        issue               <- map["issue"]
    }
}

extension Worklog {
    
    func formattedDateStarted() -> String {
        if let started = dateStarted {
            return formattedDateString(dateStr: started)
        }
        return ""
    }
    
    func formattedDateString(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date: Date = dateFormatter.date(from: dateStr)!
        dateFormatter.dateFormat = "YYYY/MM/dd, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func formattedDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let started = dateStarted {
            let date: Date = dateFormatter.date(from: started)!
            return date
        }
        return Date()
    }
    
    func secondsToHours() -> String {
        let hr: Double = Double(timeSpentSeconds! / 3600)
        return String(format: "%.f", hr)
    }
}

/*
 {
 "timeSpentSeconds": 28800,
 "billedSeconds": null,
 "dateStarted": "2017-05-22T00:00:00.000",
 "comment": "Working on issue GNA-3",
 "origin": null,
 "meta": null,
 "self": "https://onix-systems.atlassian.net/tempo-timesheets/3/worklogs/94131",
 "id": 94131,
 "author": {
 "self": "https://onix-systems.atlassian.net/rest/api/2/user?username=andriy.kramar",
 "name": "andriy.kramar",
 "key": "andriy.kramar",
 "displayName": "Andriy Kramar",
 "avatar": "https://avatar-cdn.atlassian.com/9a32ac2ba87d025552ec5ccef268d33b?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F9a32ac2ba87d025552ec5ccef268d33b%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue"
 },
 "issue": {
 "self": "https://onix-systems.atlassian.net/rest/api/2/issue/49408",
 "id": 49408,
 "projectId": 24801,
 "key": "GNA-3",
 "remainingEstimateSeconds": 28800,
 "issueType": {
 "name": "Task",
 "iconUrl": "https://onix-systems.atlassian.net/secure/viewavatar?size=xsmall&avatarId=10318&avatarType=issuetype"
 },
 "summary": "iOS app estimation"
 },
 "worklogAttributes": [],
 "workAttributeValues": []
 }
 */
