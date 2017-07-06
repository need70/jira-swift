//
//  BoardIssueCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardIssueCell: UITableViewCell {
    
    @IBOutlet weak var typeIcon: ImageViewCache!
    @IBOutlet weak var priopityIcon: ImageViewCache!
    @IBOutlet weak var avatarIcon: ImageViewCache!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var lbIssueKey: UILabel!

    var issue: Issue?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarIcon.loadImage(url: issue?.assignee?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
        avatarIcon.roundCorners()
        
        typeIcon.loadImage(url: issue?.type?.iconUrl)
        
        priopityIcon.loadImage(url: issue?.priority?.iconUrl)
        lbSummary.text = issue?.summary
        lbIssueKey.text = issue?.key

    }
}
