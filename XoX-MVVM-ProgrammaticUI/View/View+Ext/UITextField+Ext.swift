//
//  UITextField+Ext.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 7.06.2023.
//

import UIKit.UITextField

class CustomUITextfield: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder:String,
                     keyboardType: UIKeyboardType,
                     textType: UITextContentType,
                     AutocapitalizationType:UITextAutocapitalizationType,
                     isSecure:Bool) {
        self.init(frame: .zero)
        set(placeholder: placeholder,
            keyboardType: keyboardType,
            textType: textType,
            AutocapitalizationType:AutocapitalizationType,
            isSecure:isSecure
        )
    }
    
    private func set(placeholder:String,
                     keyboardType: UIKeyboardType,
                     textType: UITextContentType,
                     AutocapitalizationType:UITextAutocapitalizationType,
                     isSecure:Bool) {
        self.placeholder = placeholder
        backgroundColor  = .white
        borderStyle = .roundedRect
        self.keyboardType = keyboardType
        textContentType = textType
        autocapitalizationType = AutocapitalizationType
        isSecureTextEntry = isSecure
    }
    
}
