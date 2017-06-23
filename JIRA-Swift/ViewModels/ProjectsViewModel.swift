//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class ProjectsViewModel: BaseViewModel {
    
    var projects: [Project] = []
    
    override init() {
        super.init()
    }
    
    func getProjects(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/api/2/project"
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            print(responseObj as! [Any])
            
            let array = responseObj as! [Any]
            
            var objects: [Project] = []
            
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj = Project(JSON: dict)!
                objects.append(obj)
            }
            self.projects = objects
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
