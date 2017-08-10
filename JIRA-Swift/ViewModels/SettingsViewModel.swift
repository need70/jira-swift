//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class SettingsViewModel: ViewModel {
    
    var currentUser: User?
    
    override init() {
        super.init()
    }
    
    var appInfo: String {        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return "Version \(version)"
    }
    
    func getUser(name: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        Request().send(method: .get, url: Api.user(name).path, params: nil, successBlock: { (responseObj) in
            
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
                
        Request().send(method: .delete, url: Api.session.path, params: nil, successBlock: { (responseObj) in
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
