//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class AttachmentsViewModel: BaseViewModel {
    
    var issue: Issue?
    var attachments:[Attachment] = []
    
    var title: String {
        if let key = issue?.key {
            return "\(key): Attachments"
        }
        return "Attachments"
    }
    
    convenience init(issue: Issue?) {
        self.init()
        self.issue = issue
        if let items = issue?.attachments {
            attachments = items
        }
    }
    
    func sizeForItem(collection: UICollectionView, indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collection.width / 2 - 0.5)
        return CGSize(width: width, height: 220)
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as! AttachmentCell
        
        if indexPath.row < attachments.count {
            let item = attachments[indexPath.row]
            cell.attachment = item
        }
        return cell
    }
    
    func numberOfRows(tableView: UITableView, section: Int) -> Int {
        if attachments.count == 0 {
            return 1
        }
        return attachments.count
    }
    
}
