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
    
    func getUser(name: String, completition: @escaping responseHandler) {
        
        request.send(method: .get, url: Api.user(name).path, params: nil, completition: { (result) in
           
            switch result {
                
            case .success(let responseObj):
                
                let dict = responseObj as! [String : Any]
                let user = User(JSON: dict)
                self.currentUser = user
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
    
    func logOut(userName: String, password: String, completition: @escaping responseHandler) {
                
        request.send(method: .delete, url: Api.session.path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(_):
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
}
