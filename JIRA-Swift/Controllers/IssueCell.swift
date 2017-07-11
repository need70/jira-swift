//
//  IssueCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/11/17.
//  Copyright © 2017 home. All rights reserved.
//

class IssueCell: UITableViewCell {
    
    @IBOutlet weak var lbKey: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var svgView: SVGImageView!
    @IBOutlet weak var issueIcon: ImageViewCache!
    
    func setup(for issue: Issue?) {
        guard let item = issue else { return }
        lbKey.text = item.key
        lbSummary.text = item.summary
        svgView.loadUrl(item.type?.iconUrl)
        issueIcon.isHidden = true
    }
}
