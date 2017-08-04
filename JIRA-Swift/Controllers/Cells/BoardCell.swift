//
//  BoardIssueCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardCell: UITableViewCell {
    
    @IBOutlet weak var typeIcon: ImageViewCache!
    @IBOutlet weak var priopityIcon: ImageViewCache!
    @IBOutlet weak var avatarIcon: ImageViewCache!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var lbIssueKey: UILabel!
    @IBOutlet weak var typeView: SVGImageView!
    @IBOutlet weak var bgView: UIView!
    
    func setup(for issue: Issue?) {
        
        bgView.layer.borderColor = RGBColor(240, 240, 240).cgColor
        bgView.layer.borderWidth = 1.0
        
        guard let issue = issue else { return }
        
        avatarIcon.loadImage(url: issue.assignee?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
        avatarIcon.roundCorners()
        
        typeView.loadUrl(issue.type?.iconUrl)
        
        priopityIcon.loadImage(url: issue.priority?.iconUrl)
        lbSummary.text = issue.summary
        lbIssueKey.text = issue.key
    }
}
