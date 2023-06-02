//
//  View+Ext.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit

extension UIView {
    // MARK: - Add subviews func
    func addSubViews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
