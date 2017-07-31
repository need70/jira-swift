//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class WorklogsViewModel: ViewModel {
    
    var tempoUser: TempoUser?
    var worklogs: [Worklog] = []
    
    var title: String {
        if let name = tempoUser?.member?.displayName {
            return name + ": Worklog"
        }
        return "Worklog"
    }
    
    convenience init(tempoUser: TempoUser?) {
        self.init()
        self.tempoUser = tempoUser
    }

    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if worklogs.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell",  for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorklogCell", for: indexPath) as! WorklogCell
        
        if indexPath.row < worklogs.count {
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .white : RGBColor(250, 250, 250)
            let item = worklogs[indexPath.row]
            cell.work = item
            cell.customInit()
        }
        return cell
    }
    
    func numberOfRows(tableView: UITableView, section: Int) -> Int {
        if worklogs.count == 0 {
            return 1
        }
        return worklogs.count
    }
    
    func getWorklogs(from: String, to: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        guard let name = tempoUser?.member?.name else {
             eBlock("Tempo user name not found!")
            return
        }
        
        let path = baseURL + "/rest/tempo-timesheets/3/worklogs/?username=" + name + "&dateFrom=" + from + "&dateTo=" + to
        
        Request().send(method: .get, url: path, params: nil, successBlock: { (responseObj) in
            print(responseObj as! [Any])
            
            let array = responseObj as! [Any]
            
            var objects: [Worklog] = []
            
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj = Worklog(JSON: dict)!
                objects.append(obj)
            }
            self.worklogs = objects
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func deleteWorklog(index: Int, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let item = worklogs[index]
        guard let worklogId = item.worklogId else {
            eBlock("worklogId not found!")
            return
        }

        let path = baseURL + "/rest/tempo-timesheets/3/worklogs/\(worklogId)"
        
        Request().send(method: .delete, url: path, params: nil, successBlock: { (responseObj) in
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    

}
