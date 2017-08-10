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
    
    func getTempoUsers(sBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
    
        guard let teamId = tempoTeam?.teamId else {
            eBlock("Tempo team id not found!")
            return
        }
        
        Request().send(method: .get, url: Api.tempoUsers(teamId).path, params: nil, successBlock: { (responseObj) in
            print(responseObj as! [Any])
            
            let array = responseObj as! [Any]
            
            var objects: [TempoUser] = []
            
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj = TempoUser(JSON: dict)!
                objects.append(obj)
            }
            self.tempoUsers = objects
            sBlock()
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
