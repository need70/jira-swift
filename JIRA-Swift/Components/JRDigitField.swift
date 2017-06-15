//
//  DigitField.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol JRDigitFieldDelegate {
    func valueChanged()
}

class JRDigitField: UITextField, UITextFieldDelegate {

    var tmpValue: Int?
    var selectedValue: Int?
    var digitFieldDelegate: JRDigitFieldDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kWindowView.frame.size.width, height: 44))
        toolbar.isTranslucent = false
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancel, flex, done]
        
        self.inputAccessoryView = toolbar
        self.keyboardType = .numberPad
    }
    
    func doneAction() {
        self.endEditing(true)
       digitFieldDelegate?.valueChanged()
    }
    
    func cancelAction() {
        self.endEditing(true)
    }
}
