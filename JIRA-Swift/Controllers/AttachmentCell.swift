//
//  AttachmentCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/11/17.
//  Copyright © 2017 home. All rights reserved.
//

class AttachmentCell: UICollectionViewCell {
    
    @IBOutlet weak var lbFilename: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var attachIcon: ImageViewCache!
    @IBOutlet weak var lbSize: UILabel!
    
    func setup(for item: Attachment?) {
        guard let attachment = item else { return }
        lbFilename.text = attachment.fileName
        lbDate.text = attachment.formattedDate()
        lbSize.text = attachment.prettySizeString()
        attachIcon.loadImage(url: attachment.thumbnail, placeHolder: UIImage(named: "ic_attach"))
    }
}
