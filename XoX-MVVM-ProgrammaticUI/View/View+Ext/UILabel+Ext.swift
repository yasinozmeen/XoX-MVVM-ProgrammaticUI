//
//  UILabel+Ext.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit.UILabel

class CustomUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text:String, fontSize:CGFloat, weight: UIFont.Weight) {
        self.init(frame: .zero)
        set(text: text, fontSize: fontSize, weight: weight)
    }
    
    private func set(text:String, fontSize:CGFloat, weight: UIFont.Weight) {
        self.text = text
        font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
    
}
