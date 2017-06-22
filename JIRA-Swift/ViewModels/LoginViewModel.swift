//
//  LoginVM.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class BaseViewModel {
    
    var baseURL: String {
        guard let url = UserDefaults.standard.value(forKey: "JiraUrl") else {
            return ""
        }
        return url as! String
    }
}

class LoginViewModel: BaseViewModel {
    
    override init() {
        super.init()
    }
    
    func logIn(userName: String, password: String, fBlock: @escaping dictBlock, eBlock: @escaping stringBlock) {
        
        let params = ["username" : userName, "password" : password]
        let path = baseURL + "/rest/auth/latest/session"
        
        Request().sendPOST(url: path, params: params, successBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            fBlock(dict)
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func getCurrentUser(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/gadget/1.0/currentUser"
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            
            let dict = responseObj as! [String : Any]
            
            if let username = dict["username"] as? String {
                
                UserDefaults.standard.set(username, forKey: "Username")
                UserDefaults.standard.synchronize()
            }
            
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func getUser(name: String, fBlock: @escaping anyBlock, eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/api/2/user?username=\(name)"
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            let dict = responseObj as! [String : Any]
            let user = User(JSON: dict)
            fBlock(user)
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    //MARK: save auth data
    
    func saveJiraUrl(url: String?) {
        if let path = url {
            UserDefaults.standard.set(path, forKey: "JiraUrl")
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveLogin(login: String?) {
        if let string = login {
            KeychainItemWrapper.saveLogin(toKeychain: string)
        }
    }
    
    func savePassword(pass: String?) {
        if let string = pass {
            KeychainItemWrapper.savePass(toKeychain: string)
        }
    }
    
    func getSavedLogin() -> String {
        guard let login = KeychainItemWrapper.getLoginFromKeychain() else {
            return ""
        }
        return login as String
    }
    
    func getSavedPassword() -> String {
        guard let pass = KeychainItemWrapper.getPassFromKeychain() else {
            return ""
        }
        return pass as String
    }
    
    func shouldAutoLogin() -> Bool {
        
        let login = getSavedLogin()
        let pass = getSavedPassword()
        
        if login.characters.count > 0 && pass.characters.count > 0 {
            return true
        }
        return false
    }
    
}
