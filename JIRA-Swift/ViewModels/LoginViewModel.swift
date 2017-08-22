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
        guard let url = UserDefaults.standard.value(forKey: "JiraURL") else {
            return ""
        }
        return url as! String
    }
}

class LoginViewModel: ViewModel {
        
    func logIn(userName: String, password: String, completition: @escaping responseHandler) {
        
        let params = ["username" : userName, "password" : password]
        
        request.send(method: .post, url: Api.session.path, params: params, completition: { (result) in
            
            switch result {
                
            case .success(_):
                self.getCurrentUser(completition: completition)
                break
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
    
    func getCurrentUser(completition: @escaping responseHandler) {
                
        Request().send(method: .get, url: Api.session.path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                print(responseObj as! [String : Any])
                
                let dict = responseObj as! [String : Any]
                
                if let username = dict["name"] as? String {
                    UserDefaults.standard.set(username, forKey: "Username")
                    UserDefaults.standard.synchronize()
                }
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
    
    //MARK: save auth data
    
    func saveJiraURL(url: String?) {
        if let path = url {
            UserDefaults.standard.set(path, forKey: "JiraURL")
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
