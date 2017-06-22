
public typealias finishedBlock = () -> ()
public typealias arrayBlock = (_ array: [Any]) -> ()
public typealias dictBlock = (_ responseDict: [String: Any]?) -> ()
public typealias errorBlock = (_ error: Error?) -> ()
public typealias anyBlock = (_ any: Any?) -> ()
public typealias stringBlock = (_ string: String?) -> ()


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
    
    func getIssues(jql: String, startAt: Int, count: Int, fBlock: @escaping arrayBlock) {

        let params = ["jql" : jql, "startAt" : String(startAt), "maxResults" : String(count)]
        let path = baseURL + "/rest/api/2/search"
        
        Request().sendPOST(url: path, params: params, successBlock: { (responseObj) in
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
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    
    func logWork(issueKey: String, params: [String : String], fBlock: @escaping dictBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/worklog?adjustEstimate=auto", issueKey)
        let path = baseURL + pathComponent
        
        Request().sendPOST(url: path, params: params, successBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            fBlock(dict)
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func watchIssue(issueId: String, fBlock: @escaping finishedBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/watchers", issueId)
        let path = baseURL + pathComponent
        
        if let username = UserDefaults.standard.value(forKey: "Username") as? String {
            let params = String(format: "\"%@\"", username as String)
            
            Request().sendPOST(url: path, params: params, successBlock: { (responseObj) in
                print(responseObj as Any)
                fBlock()
                
            }, errorBlock: { (error) in
                if let err = error {
                    print(err)
                }
            })
        }
    }
        
    func getComments(issueId: String, fBlock: @escaping arrayBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", issueId)
        let path = baseURL + pathComponent
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
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
           
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func addComment(issueId: String, params: [String : String], fBlock: @escaping anyBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", issueId)
        let path = baseURL + pathComponent
        
        Request().sendPOST(url: path, params: params, successBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            let obj = Comment(JSON: dict)!
            fBlock(obj)
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func getIssue(issueId: String, fBlock: @escaping anyBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@", issueId)
        let path = baseURL + pathComponent
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            if let dict = responseObj as? [String : Any] {
                let obj: Issue = Issue(JSON: dict)!
                fBlock(obj)
            } else {
                fBlock(Issue(JSON: [:]))
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func getBoards(fBlock: @escaping anyBlock) {
        
//        let path = baseURL + "/rest/agile/1.0/board/393/issue"
        let path = baseURL + "/rest/agile/1.0/board/"
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            let dict = responseObj as! [String : Any]
            if let array = dict["values"] as? [Any] {
                var objects: [Board] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = Board(JSON: dict)!
                    objects.append(obj)
                }
                fBlock(objects)
            } else {
                fBlock([])
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func getTimeSheet(fBlock: @escaping anyBlock) {
        
        let path = baseURL + "/rest/tempo-rest/1.0/timesheet-approval?period=0813"
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])

            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
}

