//
//  AttachmentsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class AttachmentsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var viewModel = AttachmentsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationItem.title = viewModel.title
    }

    // MARK: Collection view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItem(collectionView, indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                return viewModel.cell(collectionView, indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        attachmentActions(attachment: viewModel.item(for: indexPath.row))
    }
    
    func attachmentActions(attachment: Attachment?) {
        
        guard let item = attachment else { return }
        let actions = ["Open link", "Save"]
        actionSheet(items: actions, title: "Choose action") { [weak self] (index) in
            
            switch index {
            case 0:
                self?.openLink(attachment: item)
                break
            case 1:
                self?.saveAttach(attachment: item)
                break
            default: break
            }
        }
    }
    
    func openLink(attachment: Attachment) {
        if let url = URL(string: attachment.content!) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func saveAttach(attachment: Attachment) {
        //do something for save attachment
    }
}

