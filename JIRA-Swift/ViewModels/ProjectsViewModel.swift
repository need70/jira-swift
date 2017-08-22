//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class ProjectsViewModel: ViewModel {
    
    fileprivate var projects: [Project] = []
    
    var count: Int {
        return projects.count
    }
    
    func remove() {
        projects.removeAll()
    }
    
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        if indexPath.row < projects.count {
            let item = projects[indexPath.row] as Project
            cell.setup(project: item)
        }
        return cell
    }
    
    func item(for index: Int) -> Project? {
        guard index < count else {
            return nil
        }
        return projects[index]
    }
    
    func getProjects(completition: @escaping responseHandler) {
        
        Request().send(method: .get, url: Api.projects.path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                print(responseObj as! [Any])
                
                let array = responseObj as! [Any]
                
                var objects: [Project] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = Project(JSON: dict)!
                    objects.append(obj)
                }
                self.projects = objects
                completition(.success(nil))

            case .failed(let err):
                completition(.failed(err))
            }
        
        })
    }
}
