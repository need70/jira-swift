//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class TempoTeamsViewModel: ViewModel {
    
    var tempoTeams: [TempoTeam] = []
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < tempoTeams.count {
            let team = tempoTeams[indexPath.row]
            cell.textLabel?.text = team.name
            cell.detailTextLabel?.text = team.lead
        }
        return cell
    }
    
    var count: Int {
        return tempoTeams.count
    }
    
    func getTempoTeams(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        Request().send(method: .get, url: Api.tempoTeams, params: nil, successBlock: { (responseObj) in
            print(responseObj as! [Any])
            
            let array = responseObj as! [Any]
            
            var objects: [TempoTeam] = []
            
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj = TempoTeam(JSON: dict)!
                objects.append(obj)
            }
            self.tempoTeams = objects
            fBlock()
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
