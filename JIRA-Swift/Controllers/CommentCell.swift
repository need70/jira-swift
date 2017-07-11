//
//  CommentCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/11/17.
//  Copyright © 2017 home. All rights reserved.
//


class CommentCell: UITableViewCell {
    
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var tvBody: UITextView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var avatarImage: ImageViewCache!
    
    func setup(for item: Comment?) {
        guard let comment = item else { return }
        
        lbAuthor.text = comment.author?.displayName
        lbDate.text = comment.formattedCreated()
        tvBody.text = comment.body
        avatarImage.loadImage(url: comment.author?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
        avatarImage.roundCorners()
    }
}
