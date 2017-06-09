
public typealias finishedBlock = () -> ()
public typealias arrayBlock = (_ array: Array<Any>) -> ()
public typealias dictBlock = (_ responseDict: [String: Any]?) -> ()
public typealias errorBlock = (_ error: Error?) -> ()
public typealias anyBlock = (_ any: Any?) -> ()

let URL_AUTH = "/rest/auth/latest/session"
let URL_GET_ISSUES = "/rest/api/2/search"
let URL_GET_PROJECTS = "/rest/api/2/project"
let URL_GET_USER = "/rest/api/2/user"

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
        let path = baseURL + URL_AUTH
        
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
    
    func getIssues(startAt: Int, count: Int, fBlock: @escaping arrayBlock) {
        
        let jql = "project = 'OOM' ORDER BY created"
        let params = ["jql" : jql, "startAt" : String(startAt), "maxResults" : String(count)]
        let path = baseURL + URL_GET_ISSUES
        
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
        
        let path = baseURL + URL_GET_PROJECTS
        
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
        
        let param = "?username=\(name)"
        let path = baseURL + URL_GET_USER + param
        
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
}

