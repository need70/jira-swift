//
//  Api.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 8/2/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

final class Api {
    
    private static var baseURL: String {
        guard let url = UserDefaults.standard.value(forKey: "JiraUrl") else {
            return ""
        }
        return url as! String
    }
    
    static var session: String {
        return baseURL + "/rest/auth/latest/session"
    }
    
    static var issuesList: String {
        return baseURL + "/rest/api/2/search"
    }
    
    static func issue(_ key: String) -> String {
        let pathComponent = String(format: "/rest/api/2/issue/%@", key)
        return baseURL + pathComponent
    }
    
    static func user(_ name: String) -> String {
        let path = baseURL + "/rest/api/2/user?username=" + name
        return path
    }
    
    static func watchIssue(_ key: String) -> String {
        let pathComponent = String(format: "/rest/api/2/issue/%@/watchers", key)
        return baseURL + pathComponent
    }
    static func unwatchIssue(_ key: String, _ name: String) -> String {
        let pathComponent = String(format: "/rest/api/2/issue/%@/watchers?username=%@", key, name)
        return baseURL + pathComponent
    }
    
    static func transitions(_ key: String) -> String {
        let pathComponent = String(format: "/rest/api/2/issue/%@/transitions", key)
        return baseURL + pathComponent
    }
    
    static func comments(_ key: String) -> String {
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", key)
        return baseURL + pathComponent
    }
    
    static func logWork(_ key: String) -> String {
        let pathComponent = String(format: "/rest/api/2/issue/%@/worklog?adjustEstimate=auto", key)
        return baseURL + pathComponent
    }
    
    static var createmeta: String {
        return baseURL + "/rest/api/2/issue/createmeta"
    }
   
    static var issueCreate: String {
        return baseURL + "/rest/api/2/issue/"
    }
    
    static var boards: String {
        return baseURL + "/rest/agile/1.0/board/"
    }
    
    static func boardCols(_ boardId: Int) -> String {
        let pathComponent = String(format: "/rest/agile/1.0/board/%zd/configuration", boardId)
        return baseURL + pathComponent
    }
    
    static func boardIssues(_ boardId: Int, _ name: String) -> String {
        let pathComponent = String(format: "/rest/agile/1.0/board/%zd/issue?startAt=0&maxResults=1000", boardId)
        let fieldComponent = "&fields=summary,assignee,status,issuetype,priority"
        let statusComponent = String(format: "&jql=status in ('%@')", name)
        let path = baseURL + pathComponent + fieldComponent + statusComponent.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        return path
    }
    
    static var projects: String {
        return baseURL + "/rest/api/2/project"
    }

    //tempo
    
    static var tempoTeams: String {
        return baseURL + "/rest/tempo-teams/1/team"
    }
    
    static func tempoUsers(_ id: Int) -> String {
        let pathComponent = String(format: "/rest/tempo-teams/2/team/%zd/member", id)
        return baseURL + pathComponent
    }
    
    static func tempoWorklogs(_ name: String, from: String, to: String) -> String {
        let path = baseURL + "/rest/tempo-timesheets/3/worklogs/?username=" + name + "&dateFrom=" + from + "&dateTo=" + to
        return path
    }
}

