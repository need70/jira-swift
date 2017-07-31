//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class AttachmentsViewModel: ViewModel {
    
    fileprivate var issue: Issue?
    fileprivate var attachments:[Attachment] = []
    
    var title: String {
        if let key = issue?.key {
            return "\(key): Attachments"
        }
        return "Attachments"
    }
    
    var count: Int {
        return attachments.count
    }
    
    convenience init(issue: Issue?) {
        self.init()
        self.issue = issue
        if let items = issue?.attachments {
            attachments = items
        }
    }
    
    func item(for index: Int) -> Attachment? {
        guard index < count else {
            return nil
        }
        return attachments[index]
    }
    
    func sizeForItem(_ collection: UICollectionView, _ indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collection.width / 2 - 0.5)
        return CGSize(width: width, height: 220)
    }
    
    func cell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as! AttachmentCell
        
        if indexPath.row < attachments.count {
            cell.setup(for: attachments[indexPath.row])
        }
        return cell
    }
    
    func numberOfRows(_ tableView: UITableView, _ section: Int) -> Int {
        if attachments.count == 0 {
            return 1
        }
        return attachments.count
    }
    
}
