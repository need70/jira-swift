//
//  Api.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 8/2/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

enum Api {
    
    case session
    case issuesList
    case issue(String)
    case user(String)
    case watchIssue(String)
    case unwatchIssue(String, String)
    case transitions(String)
    case comments(String)
    case logWork(String)
    case createmeta
    case issueCreate
    case boards
    case boardCols(Int)
    case boardIssues(Int, String)
    case projects
    case tempoTeams
    case tempoUsers(Int)
    case tempoWorklogs(String, String, String)
    
    private var baseURL: String  {
        guard let url = UserDefaults.standard.value(forKey: "JiraURL") else {
            return ""
        }
        return url as! String
    }
    
    var path: String {
        
        switch self {
        case .session:
            return baseURL + "/rest/auth/latest/session"
            
        case .issuesList:
            return baseURL + "/rest/api/2/search"
            
        case .issue(let key):
            let pathComponent = String(format: "/rest/api/2/issue/%@", key)
            return baseURL + pathComponent
        
        case .user(let name):
            let path = baseURL + "/rest/api/2/user?username=" + name
            return path

        case .watchIssue(let key):
            let pathComponent = String(format: "/rest/api/2/issue/%@/watchers", key)
            return baseURL + pathComponent
            
        case .unwatchIssue(let key, let name):
            let pathComponent = String(format: "/rest/api/2/issue/%@/watchers?username=%@", key, name)
            return baseURL + pathComponent
        
        case .transitions(let key):
            let pathComponent = String(format: "/rest/api/2/issue/%@/transitions", key)
            return baseURL + pathComponent
            
        case .comments(let key):
            let pathComponent = String(format: "/rest/api/2/issue/%@/comment", key)
            return baseURL + pathComponent

        case .logWork(let key):
            let pathComponent = String(format: "/rest/api/2/issue/%@/worklog?adjustEstimate=auto", key)
            return baseURL + pathComponent

        case .createmeta:
            return baseURL + "/rest/api/2/issue/createmeta"

        case .issueCreate:
            return baseURL + "/rest/api/2/issue/"

        case .boards:
            return baseURL + "/rest/agile/1.0/board/"

        case .boardCols(let boardId):
            let pathComponent = String(format: "/rest/agile/1.0/board/%zd/configuration", boardId)
            return baseURL + pathComponent

        case .boardIssues(let boardId, let status):
            let pathComponent = String(format: "/rest/agile/1.0/board/%zd/issue?startAt=0&maxResults=1000", boardId)
            let fieldComponent = "&fields=summary,assignee,status,issuetype,priority"
            let statusComponent = String(format: "&jql=status in ('%@') order by Created DESC", status)
            let path = baseURL + pathComponent + fieldComponent + statusComponent.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            return path

        case .projects:
            return baseURL + "/rest/api/2/project"

        case .tempoTeams:
            return baseURL + "/rest/tempo-teams/1/team"

        case .tempoUsers(let teamId):
            let pathComponent = String(format: "/rest/tempo-teams/2/team/%zd/member", teamId)
            return baseURL + pathComponent
            
        case .tempoWorklogs(let name, let from, let to):
            let path = baseURL + "/rest/tempo-timesheets/3/worklogs/?username=" + name + "&dateFrom=" + from + "&dateTo=" + to
            return path

        }
    }
}
