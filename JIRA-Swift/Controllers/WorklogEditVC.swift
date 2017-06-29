//
//  LogWorkVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/9/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol WorklogEditDelegate {
    func logWorkUpdated()
}

class WorklogEditVC: UITableViewController, JRDigitFieldDelegate, JRDateFieldDelegate {

    var worklog: Worklog?
    var _delegate: WorklogEditDelegate?
    
    @IBOutlet weak var lbIssueKey: UILabel!
    @IBOutlet weak var tfWeek: JRDigitField!
    @IBOutlet weak var tfDay: JRDigitField!
    @IBOutlet weak var tfHour: JRDigitField!
    @IBOutlet weak var tfMinute: JRDigitField!
    @IBOutlet weak var lbTimeSpent: UILabel!
    @IBOutlet weak var tfDate: JRDateField!
    @IBOutlet weak var tvWorkDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfWeek.digitFieldDelegate = self
        tfDay.digitFieldDelegate = self
        tfHour.digitFieldDelegate = self
        tfMinute.digitFieldDelegate = self
        tfDate.dateFieldDelegate = self
        
        setupUI()
    }
    
    override func leftBarButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func rightBarButtonPressed() {
        if lbTimeSpent.text != "" {
            logWork()
        } else {
            alert(title: "Alert", message: "Enter the spent time, please!")
        }
    }
    
    func setupUI() {
        
        addRightBarButton(image: nil, title: "Done")
        addLeftBarButton(image: nil, title: "Cancel")
        
        tvWorkDescription.layer.borderColor = kSystemSeparatorColor.cgColor
        tvWorkDescription.layer.borderWidth = 1
        tvWorkDescription.layer.cornerRadius = 5.0
        
        if let work = worklog {
            tvWorkDescription.text = work.comment
            lbIssueKey.text = work.issue?.key
            tfHour.text = work.secondsToHours()
            setupDateField(work.formattedDate())
            setupTimeLabel()
        }
    }
    
    func logWork() {
        view.endEditing(true)
        ToastView.show("Updating...")
        
        let startedDate = Utils.formattedStringDateFrom(date: Date())
        var params: [String : String] = ["timeSpent" : lbTimeSpent.text!]
        
        if tvWorkDescription.text != "" {
            params["comment"] = tvWorkDescription.text
        }
        
        if tfDate.text != "" {
            params["started"] = startedDate
        }
        
        print("params = \(params)")
        
//        kMainModel.logWork(issueKey: (issue?.issueId)!, params: params) { (responceDict) in
//            print(responceDict ?? "dsa")
//            ToastView.hide(fBlock: {
//                self.dismiss(animated: true, completion: nil)
//            })
//        }
    }
    
    func setupTimeLabel() {
        
        var weeks = ""
        var days = ""
        var hours = ""
        var minutes = ""
        
        if tfWeek.text != "" {
            weeks = tfWeek.text! + "w "
        }
        if tfDay.text != "" {
            days = tfDay.text! + "d "
        }
        if tfHour.text != "" {
            hours = tfHour.text! + "h "
        }
        
        if tfMinute.text != "" {
            minutes = tfMinute.text! + "m "
        }
        lbTimeSpent.text = weeks + days + hours + minutes
    }
    
    func setupDateField(_ date: Date) {
        Utils.dateFormatter.dateFormat = "YYYY/MM/dd, HH:mm"
        let string =  Utils.dateFormatter.string(from: date)
        tfDate.text = string
    }
    
    //MARK: - DigitFieldDelegate
    
    func valueChanged() {
        setupTimeLabel()
    }
    
    func selectedDate(date: Date, tag: Int) {
        setupDateField(date)
    }
    
     //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        view.endEditing(true)
    }
}
