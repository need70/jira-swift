//
//  LogWorkVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/9/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol LogWorkDelegate {
    func logWorkUpdated()
}

class LogWorkVC: UITableViewController {

    var viewModel = LogWorkViewModel()
    var _delegate: LogWorkDelegate?
    
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
        guard lbTimeSpent.text != "" else {
            alert(title: "Alert", message: "Enter the spent time, please!")
            return
        }
        logWork()
    }
    
    func setupUI() {
        navigationItem.title = viewModel.title
        
        addRightBarButton(image: nil, title: "Log")
        addLeftBarButton(image: nil, title: "Cancel")
        
        tvWorkDescription.layer.borderColor = kSystemSeparatorColor.cgColor
        tvWorkDescription.layer.borderWidth = 1
        tvWorkDescription.layer.cornerRadius = 5.0
        
        setupTimeLabel()
        setupDateField(Date())
    }
    
    func logWork() {
        
        view.endEditing(true)
        ToastView.show("Logging Work...")
        
        let startedDate = Utils.formattedStringDateFrom(date: tfDate.picker.date)
        var params: [String : String] = ["timeSpent" : lbTimeSpent.text!]
        
        if tvWorkDescription.text != "" {
            params["comment"] = tvWorkDescription.text
        }
        
        if tfDate.text != "" {
            params["started"] = startedDate
        }
        
        print("params = \(params)")
        
        viewModel.logWork(params: params, sBlock: { [weak self] (responceDict) in
            ToastView.hide(fBlock: {
                self?.dismiss(animated: true, completion: nil)
            })
        }) { [weak self] (errString) in
            ToastView.errHide(fBlock: {
                self?.alert(title: "Error", message: errString)
            })
        }
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
    
     //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension LogWorkVC: JRDigitFieldDelegate, JRDateFieldDelegate {
    
    //MARK: - DigitFieldDelegate
    
    func valueChanged() {
        setupTimeLabel()
    }
    
    func selectedDate(date: Date, tag: Int) {
        setupDateField(date)
    }
}
