//
//  WorklogsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/26/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class WorklogsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, JRDateFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfFrom: JRDateField!
    @IBOutlet weak var tfTo: JRDateField!
    
    var viewModel = WorklogsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = viewModel.title
        setupDefaults()
        
        AKActivityView.add(to: view)
        getWorklogs()
    }
    
    func setupDefaults() {
        tfFrom.dateFieldDelegate = self
        tfTo.dateFieldDelegate = self
        
        let fromDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let toDate = Date()
                
        setupDateField(fromDate!, for: tfFrom)
        setupDateField(toDate, for: tfTo)
    }
    
    func setupDateField(_ date: Date, for field: JRDateField) {
        Utils.dateFormatter.dateFormat = "YYYY-MM-dd"
        let string =  Utils.dateFormatter.string(from: date)
        field.picker.date = date
        field.picker.maximumDate = Date()
        field.picker.datePickerMode = .date
        field.text = string
    }

    func getWorklogs() {
        viewModel.getWorklogs(from: tfFrom.text!, to: tfTo.text!, completition: { [weak self] (result) in
            
            switch result {
                
            case .success(_):
                self?.tableView.reloadData()
                AKActivityView.remove(animated: true)

            case .failed(let err):
                AKActivityView.remove(animated: true)
                self?.alert(title: "Error", message: err)

            }
        })
    }
    
    func deleteWorklog(index: Int) {
        ToastView.show("Deleting...")
        viewModel.deleteWorklog(index: index, completition: { [weak self] (result) in
            
            switch result {
                
            case .success(_):
                ToastView.hide()
                self?.validate()

            case .failed(let err):
                ToastView.errHide(fBlock: {
                    self?.alert(title: "Error", message: err)
                })

            }
        })
    }
    
    func validate() {
        if tfFrom.text?.characters.count == 0 || tfTo.text?.characters.count == 0 {
            alert(title: "Alert", message: "Please fill date fields!")
        }
        
        AKActivityView.add(to: view)
        getWorklogs()
    }
    
    func deleteAction(for index: Int) {
        actionSheet(items: ["Sure"], title: "Do You want to delete this worklog?") { [weak self] (index) in
            if index == 0 {
                self?.deleteWorklog(index: index)
            }
        }
    }
    
    func editAction(for index: Int) {
        let item = viewModel.worklogs[index]
        Presenter.presentWorklogEdit(from: self, worklog: item)
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        validate()
    }

    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteAction(for: indexPath.row)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editAction(for: indexPath.row)
        }
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView: tableView, indexPath: indexPath)
    }
    
    //MARK: DateField delegate
    
    func selectedDate(date: Date, tag: Int) {
        if tag == 1 {
            setupDateField(date, for: tfFrom)
        } else {
            setupDateField(date, for: tfTo)
        }
    }
}

//MARK: - WorklogCell

class WorklogCell: UITableViewCell {
    
    var work: Worklog?
    
    @IBOutlet weak var lbIssueKey: UILabel!
    @IBOutlet weak var lbTimeSpent: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    
    func customInit() {
        if let work = work {
            lbIssueKey.text = work.issue?.key
            lbTimeSpent.text = work.secondsToHours() + "h"
            lbDate.text = work.formattedDateStarted()
            lbComment.text = work.comment
        }
    }
    
}
