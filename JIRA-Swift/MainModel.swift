
public typealias finishedBlock = () -> ()
public typealias arrayBlock = (_ array: [Any]) -> ()
public typealias dictBlock = (_ responseDict: [String: Any]?) -> ()
public typealias errorBlock = (_ error: Error?) -> ()
public typealias anyBlock = (_ any: Any?) -> ()

import UIKit

let kMainModel = MainModel.instance

class MainModel
{
    static let instance = MainModel()
    
    var currentUser: User?
    
    var baseURL: String {
        if let url = UserDefaults.standard.value(forKey: "JiraUrl") {
            return url as! String
        }
        return ""
    }
    
    func auth(userName: String, password: String, fBlock: @escaping dictBlock) {
        
        let params = ["username" : userName, "password" : password]
        let path = baseURL + "/rest/auth/latest/session"
        
        Request().sendPOST(url: path, params: params, sBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            fBlock(dict)
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func getIssues(jql: String, startAt: Int, count: Int, fBlock: @escaping arrayBlock) {

        let params = ["jql" : jql, "startAt" : String(startAt), "maxResults" : String(count)]
        let path = baseURL + "/rest/api/2/search"
        
        Request().sendPOST(url: path, params: params, sBlock: { (responseObj) in
            print(responseObj as Any)
            
            let dict = responseObj as! [String : Any]
            if let array: [Any] = dict["issues"] as? [Any] {
                
                var objects: [Issue] = []
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj: Issue = Issue(JSON: dict)!
                    objects.append(obj)
                }
                fBlock(objects)
            } else {
                fBlock([])
            }
            
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func getProjects(fBlock: @escaping arrayBlock) {
        
        let path = baseURL + "/rest/api/2/project"
        
        Request().sendGET(url: path, sBlock: { (responseObj) in
            print(responseObj as! [Any])
            
            let array = responseObj as! [Any]
            var objects: [Project] = []
            
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj = Project(JSON: dict)!
                objects.append(obj)
            }
            
            fBlock(objects)
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func getCurrentUser(fBlock: @escaping finishedBlock) {
        
        let path = baseURL + "/rest/gadget/1.0/currentUser"
        
        Request().sendGET(url: path, sBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            
            let dict = responseObj as! [String : Any]
            self.currentUser = User(JSON: [:])!
            
            if let username = dict["username"] as? String {
                self.currentUser?.name = username
            }
            
            fBlock()
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func getUser(name: String, fBlock: @escaping anyBlock) {
        
        let path = baseURL + "/rest/api/2/user?username=\(name)"
        
        Request().sendGET(url: path, sBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            let dict = responseObj as! [String : Any]
            let user = User(JSON: dict)
            fBlock(user)
            
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func logWork(issueKey: String, params: [String : String], fBlock: @escaping dictBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/worklog?adjustEstimate=auto", issueKey)
        let path = baseURL + pathComponent
        
        Request().sendPOST(url: path, params: params, sBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            fBlock(dict)
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func watchIssue(issueId: String, fBlock: @escaping finishedBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/watchers", issueId)
        let path = baseURL + pathComponent
        
        let params: [String : String] = [:]
        
        Request().sendPOST(url: path, params: params, sBlock: { (responseObj) in
            print(responseObj as Any)
                fBlock()
            
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
        
    func getComments(issueId: String, fBlock: @escaping arrayBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", issueId)
        let path = baseURL + pathComponent
        
        Request().sendGET(url: path, sBlock: { (responseObj) in
            
            let dict = responseObj as! [String : Any]
            
            if let array = dict["comments"] as? [Any] {
                var objects: [Comment] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = Comment(JSON: dict)!
                    objects.append(obj)
                }
                fBlock(objects)
            } else {
                fBlock([])
            }
           
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func addComment(issueId: String, params: [String : String], fBlock: @escaping anyBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", issueId)
        let path = baseURL + pathComponent
        
        Request().sendPOST(url: path, params: params, sBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            let obj = Comment(JSON: dict)!
            fBlock(obj)
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
    
    func getIssue(issueId: String, fBlock: @escaping anyBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@", issueId)
        let path = baseURL + pathComponent
        
        Request().sendGET(url: path, sBlock: { (responseObj) in
            
            if let dict = responseObj as? [String : Any] {
                let obj: Issue = Issue(JSON: dict)!
                fBlock(obj)
            } else {
                fBlock(Issue(JSON: [:]))
            }
            
        }, eBlock: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
}

