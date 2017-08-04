//
//  IssuesListViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/11/17.
//  Copyright © 2017 home. All rights reserved.
//

let ISSUES_PER_PAGE = 20

class IssuesListViewModel: ViewModel {
    
    fileprivate var issues: [Issue] = []
    fileprivate var pagingEnabled = false
    fileprivate var isLoading = false
    fileprivate var jql: String?
    fileprivate var orderBy: String?
    fileprivate var categoryTitle: String?
    
    convenience init(jql: String?, orderBy: String?, categoryTitle: String?) {
        self.init()
        self.jql = jql
        self.orderBy = orderBy
        self.categoryTitle = categoryTitle
    }
    
    var count: Int { return issues.count }
    
    var title: String {
        guard let titleStr = categoryTitle else {
            return "Issues"
        }
        return titleStr
    }
    
    func remove() { issues.removeAll() }
    
    func setOrder(_ str: String?) {
        orderBy = str
    }
    
    func numberOfRows(_ tableView: UITableView, _ section: Int) -> Int {
        if issues.count == 0 {
            return 1
        }
        return pagingEnabled ? issues.count + 1 : issues.count
    }
    
    func heightForRow(_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat {
        if issues.count == 0 {
            return 100
        }
        return 60
    }
    
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        if issues.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell")!
            return cell
        }
        
        if indexPath.row >= issues.count {
            return LoadingCell.instance()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell") as! IssueCell
        
        if indexPath.row < issues.count {
            let issue = issues[indexPath.row]
            cell.setup(for: issue)
        }
        return cell
    }
    
    func issueFor(index: Int) -> Issue {
        return issues[index]
    }
    
    func getOrderBy() -> String {
        if orderBy != nil {
            return " order by " + orderBy!
        } else {
            return " order by Created DESC"
        }
    }
    
    func getIssues(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        if isLoading { return }
        pagingEnabled = true
        isLoading = true
        
        var jqlString = ""
        
        if let jql = jql {
            jqlString = jql
        }
        
        jqlString += getOrderBy()
        
        let params = ["jql" : jqlString, "startAt" : String(count), "maxResults" : String(ISSUES_PER_PAGE)]
        
        Request().send(method: .post, url: Api.issuesList, params: params, successBlock: { [weak self] (responseObj) in
            print(responseObj as Any)
            
            let dict = responseObj as! [String : Any]
            if let array: [Any] = dict["issues"] as? [Any] {
                
                self?.pagingEnabled = (array.count < ISSUES_PER_PAGE) ? false : true
                
                var objects: [Issue] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj: Issue = Issue(JSON: dict)!
                    objects.append(obj)
                }
                self?.issues += objects
                self?.isLoading = false
                fBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
