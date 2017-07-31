//
//  BoardDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/29/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class BoardDetailsVC: UIViewController {

    var viewModel = BoardDetailsViewModel()
    var currentColumn: Int = 0
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbColumnTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        collection.roundCorners(radius: 5)
        collection.addBorder(color: RGBColor(241, 241, 241), width: 1)
        
        AKActivityView.add(to: view)
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNtf(ntf:)), name: NSNotification.Name(rawValue: "BoardIssueTapped"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func getData() {
        viewModel.getBoardColumns(fBlock: { [weak self] in
            self?.setupUI()
            AKActivityView.remove(animated: true)
        }) { [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }
    
    func handleNtf(ntf: Notification) {
        let issue = ntf.object as! Issue
        Presenter.pushIssueDetails(from: navigationController, issueKey: issue.key)
    }
    
    func setupUI() {
        pageControl.numberOfPages = viewModel.count
        lbColumnTitle.text = viewModel.nameAndCount(index: currentColumn)
        collection.reloadData()
    }
}

extension BoardDetailsVC:  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
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




