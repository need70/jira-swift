//
//  IssuesViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class BaseViewModel {
    
    var baseURL: String {
        if let url = UserDefaults.standard.value(forKey: "JiraUrl") {
            return url as! String
        }
        return ""
    }
}

let kIssuesPerPage = 20

class IssuesViewModel: BaseViewModel {
    
    var issues: [Issue] = []
    var completition: finishedBlock = {}
    var pagingEnabled = false
    var isLoading = false
    
    override init() {
        super.init()
        getIssues()
    }
    
    func getIssues() {
        
        if isLoading { return }
        pagingEnabled = true
        isLoading = true
        
        getIssues(jql: "project = 'EST' ORDER BY created", startAt: issues.count, count: kIssuesPerPage) { (array) in
            self.pagingEnabled = (array.count < kIssuesPerPage) ? false : true
            self.issues = array as! [Issue]
            self.completition()
            self.isLoading = false
        }
    }
    
    func getIssues(jql: String, startAt: Int, count: Int, fBlock: @escaping arrayBlock) {
        

        let params = ["jql" : jql, "startAt" : String(startAt), "maxResults" : String(count)]
        let path = baseURL + URL_GET_ISSUES
        
        Request().sendPOST(url: path, params: params, sBlock: { (responseObj) in
            print(responseObj as Any)
            
            let dict = responseObj as! [String : Any]
            self.mapIssues(dict: dict, block: fBlock)
            
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func mapIssues(dict: [String : Any], block: @escaping arrayBlock) {
        
        if let array: [Any] = dict["issues"] as? [Any] {
            var objects: [Issue] = []
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj: Issue = Issue(JSON: dict)!
                objects.append(obj)
            }
            block(objects)
        } else {
            block([])
        }
    }
    
    func cell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        
        if indexPath.row >= issues.count {
            return LoadingCell.instance()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell") as! IssueCell
        if indexPath.row < issues.count {
            cell.issue = issues[indexPath.row]
        }
        return cell
    }
    
    func pushToDetails(navCon: UINavigationController?, indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let idvc = storyboard.instantiateViewController(withIdentifier: "IssueContainerVC") as! IssueContainerVC
        
        if indexPath.row < issues.count {
            idvc.issue = issues[indexPath.row]
        }
        navCon?.pushViewController(idvc, animated: true)
    }
}
