//
//  ProjectCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/11/17.
//  Copyright © 2017 home. All rights reserved.
//

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iconImage: ImageViewCache!
    
    func setup(project: Project?) {
        guard let item = project else { return }
        lbTitle.text = item.name
        iconImage.loadImage(url: item.iconUrl!, placeHolder: UIImage(named: "tab_project"))
        iconImage.roundCorners()
    }
}
