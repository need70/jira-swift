//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class SettingsViewModel: BaseViewModel {
    
    var currentUser: User?
    
    override init() {
        super.init()
    }
    
    func getUser(name: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/api/2/user?username=" + name
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            print(responseObj as! [String : Any])
            let dict = responseObj as! [String : Any]
            let user = User(JSON: dict)
            self.currentUser = user
            fBlock()
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func logOut(userName: String, password: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let params = ["username" : userName, "password" : password]
        let path = baseURL + "/rest/auth/latest/session"
        
        Request().sendDELETE(url: path, params: params, successBlock: { (responseObj) in
            print(responseObj!)
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
