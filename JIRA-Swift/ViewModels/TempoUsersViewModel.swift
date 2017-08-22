//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class TempoUsersViewModel: ViewModel {
    
    var tempoTeam: TempoTeam?
    var tempoUsers: [TempoUser] = []
    
    convenience init(tempoTeam: TempoTeam?) {
        self.init()
        self.tempoTeam = tempoTeam
    }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TempoUsersCell", for: indexPath) as! TempoUsersCell
        
        if indexPath.row < tempoUsers.count {
            let user = tempoUsers[indexPath.row]
            cell.user = user
            cell.customInit()
        }
        return cell
    }
    
    var count: Int {
        return tempoUsers.count
    }
    
    func getTempoUsers(completition: @escaping responseHandler) {
    
        guard let teamId = tempoTeam?.teamId else {
            completition(.failed("Tempo team id not found!"))
            return
        }
        
        request.send(method: .get, url: Api.tempoUsers(teamId).path, params: nil, completition: { (result) in
  
            switch result {
                
            case .success(let responseObj):
                
                print(responseObj as! [Any])
                
                let array = responseObj as! [Any]
                
                var objects: [TempoUser] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = TempoUser(JSON: dict)!
                    objects.append(obj)
                }
                self.tempoUsers = objects
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
            
        })
    }
}
