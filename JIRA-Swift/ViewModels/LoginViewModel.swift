//
//  LoginVM.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class ViewModel {
    
    var baseURL: String {
        guard let url = UserDefaults.standard.value(forKey: "JiraUrl") else {
            return ""
        }
        return url as! String
    }
}

class LoginViewModel: ViewModel {
        
    func logIn(userName: String, password: String, sBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let params = ["username" : userName, "password" : password]
        
        Request().send(method: .post, url: Api.session, params: params, successBlock: { (responseObj) in
            self.getCurrentUser(sBlock: sBlock, eBlock: eBlock)
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func getCurrentUser(sBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
                
        Request().send(method: .get, url: Api.session, params: nil, successBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            
            let dict = responseObj as! [String : Any]
            
            if let username = dict["name"] as? String {
                UserDefaults.standard.set(username, forKey: "Username")
                UserDefaults.standard.synchronize()
            }
            sBlock()
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
                
        guard login.characters.count > 0 && pass.characters.count > 0 else {
            return false
        }
        return true
    }
    
}
