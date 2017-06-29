//
//  BoardDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/29/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class BoardDetailsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    var viewModel = BoardDetailsViewModel()
    var currentColumn: Int = 0
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbColumnTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        
        AKActivityView.add(to: view)
        getColumns()
    }
    
    func getColumns() {
        viewModel.getBoardColumns(fBlock: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupUI()
            AKActivityView.remove(animated: true)
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }
    
    func setupUI() {
        pageControl.numberOfPages = viewModel.columns.count
        lbColumnTitle.text = viewModel.columnName(index: currentColumn)
        collection.reloadData()
    }
    
    //MARK: Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collection.width, height: collection.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.cell(collectionView:collectionView, indexPath:indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentColumn = Int(collection.contentOffset.x / collection.width)
        pageControl.currentPage = currentColumn
        setupUI()
    }
}

// MARK: - BoardCollectionCell

class BoardCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let issues: [Issue] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK:  UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "issue"
        return cell
    }
}


class BoardDetailsViewModel: BaseViewModel {
    
    var board: Board?
    fileprivate var columns: [BoardColumn?] = []
    
    var title: String {
        if let name = board?.name {
            return name
        }
        return "Board"
    }
    
    var count:Int {
        return columns.count
    }
    
    convenience init(board: Board) {
        self.init()
        self.board = board
    }
    
    func columnName(index: Int) -> String {
        
        if let col = columns[index], let name = col.name {
            return name
        }
        return ""
    }
    
    func getBoardColumns(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let boardId = board?.boardId else { return }
        
        let pathComponent = String(format: "/rest/agile/1.0/board/%zd/configuration", boardId)
        let path = baseURL + pathComponent
        
        Request().send(method: .get, url: path, params: nil, successBlock: { (responseObj) in
            
            let dict = responseObj as! [String : Any]
            let subDict = dict["columnConfig"] as! [String : Any]
            
            if let array = subDict["columns"] as? [Any] {
                
                var objects: [BoardColumn] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = BoardColumn(JSON: dict)!
                    
                    if obj.statuses.count != 0 {
                        objects.append(obj)
                    }
                }
                self.columns = objects
                fBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionCell", for: indexPath) as! BoardCollectionCell
        
//        if indexPath.row < attachments.count {
//            let item = attachments[indexPath.row]
//            cell.attachment = item
//        }
        return cell
    }
    
//    func numberOfRows(tableView: UITableView, section: Int) -> Int {
//        return attachments.count
//    }

    
    
}
