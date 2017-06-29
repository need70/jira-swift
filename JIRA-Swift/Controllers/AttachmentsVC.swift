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
        return viewModel.attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItem(collection: collectionView, indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                return viewModel.cell(collectionView:collectionView, indexPath:indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row < viewModel.attachments.count {
            let item = viewModel.attachments[indexPath.row]
            attachmentActions(attachment: item)
        }
    }
    
    func attachmentActions(attachment: Attachment) {
        let actions = ["Open link", "Save"]
        actionSheet(items: actions, title: "Choose action") { [weak self] (index) in
            
            guard let weakSelf = self else { return }
            switch index {
            case 0:
                weakSelf.openLink(attachment: attachment)
                break
            case 1:
                weakSelf.saveAttach(attachment: attachment)
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

// MARK: - AttachmentCell

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
