//
//  BoardDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/29/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class BoardInfoVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnColumn: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!

    var viewModel = BoardInfoViewModel()
    var currentColumn: Int = 0
    var isLoading = false
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl.addTarget(self, action: #selector(getIssuesForColumn), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AKActivityView.add(to: view)
        getColumns()
    }
    
    func getColumns() {
        viewModel.getBoardColumns(fBlock: { [weak self] in
            self?.getIssuesForColumn()
        }) { [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }
    
    func getIssuesForColumn() {
        isLoading = true
        viewModel.getBoardIssues(index: currentColumn, fBlock: { [weak self] in
            AKActivityView.remove(animated: true)
            self?.isLoading = false
            self?.refreshControl.endRefreshing()
            self?.setupUI()
        }) {  [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }
    
    func setupUI() {
        let title = viewModel.nameAndCount(index: currentColumn)
        btnColumn.setTitle(title, for: .normal)
        btnPrev.isHidden = currentColumn == 0 ? true : false
        btnNext.isHidden = currentColumn == viewModel.columnsCount - 1 ? true : false
        tableView.reloadData()
    }
    
    @IBAction func btnColumnAction(_ sender: UIButton) {
        
        actionSheet(items: viewModel.colTitles, title: "Select column") { [weak self] (index) in
            self?.currentColumn = index
            AKActivityView.add(to: self?.tableView)
            self?.getIssuesForColumn()
        }
    }
    
    @IBAction func prevAction(_ sender: UIButton) {
        
        guard !isLoading else {
            return
        }
        currentColumn -= 1
        AKActivityView.add(to: tableView)
        getIssuesForColumn()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {

        guard !isLoading else {
            return
        }
        currentColumn += 1
        AKActivityView.add(to: tableView)
        getIssuesForColumn()
    }
}

extension BoardInfoVC:  UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let issue = viewModel.issueFor(index: indexPath.row)
        Presenter.pushIssueDetails(from: navigationController, issueKey: issue?.key)
    }
}




