//
//  AttachmentsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class AttachmentsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var issue: Issue?
    var attachments: [Attachment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let key = issue?.key {
            navigationItem.title = "\(key): Attachments"
        }
        
        if let items = issue?.attachments {
            attachments = items
        }
    }

    // MARK: - Collection view data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collectionView.width / 2 - 0.5)
        return CGSize(width: width, height: 220)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as! AttachmentCell
        
        if indexPath.row < attachments.count {
            let item = attachments[indexPath.row]
            cell.attachment = item
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row < attachments.count {
            let item = attachments[indexPath.row]
            attachmentActions(attachment: item)
        }
    }
    
    func attachmentActions(attachment: Attachment) {
        let actions = ["Open link", "Save"]
        Utils.showActionSheet(items: actions, title: "Choose action", vc: self) { (index) in
            switch index {
            case 0:
                self.openLink(attachment: attachment)
                break
            case 1:
                self.saveAttach(attachment: attachment)
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

    }
}


class AttachmentCell: UICollectionViewCell {
    
    @IBOutlet weak var lbFilename: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var attachIcon: ImageViewCache!
    @IBOutlet weak var lbSize: UILabel!
    
    var attachment: Attachment?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let attachment = attachment {
            lbFilename.text = attachment.fileName
            lbDate.text = attachment.formattedDate()
            lbSize.text = attachment.prettySizeString()
            attachIcon.loadImage(url: attachment.thumbnail, placeHolder: UIImage(named: "ic_attach"))
        }
    }
}
