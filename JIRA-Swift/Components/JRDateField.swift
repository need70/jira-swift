//
//  JRDateField.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol JRDateFieldDelegate {
    func selectedDate(date: Date, tag: Int)
}

class JRDateField: UITextField {
    
    var dateFieldDelegate: JRDateFieldDelegate?
    var picker = UIDatePicker()
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        picker.datePickerMode = .dateAndTime
        picker.backgroundColor = .white
        picker.date = Date()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kWindow.frame.size.width, height: 44))
        toolbar.isTranslucent = false
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancel, flex, done]
        
        self.inputAccessoryView = toolbar
        self.inputView = picker
    }
    
    func doneAction() {
        self.endEditing(true)
        dateFieldDelegate?.selectedDate(date: picker.date, tag: self.tag)
    }
    
    func cancelAction() {
        self.endEditing(true)
    }

}
