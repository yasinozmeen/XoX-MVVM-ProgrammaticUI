//
//  ViewController.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit.UIViewController
import SnapKit


final class LoginPageVC: UIViewController {
// MARK: - Properties
    let loginPageView = LoginPageView()
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configure()
        loginPageView.configure()
        
        
    }
    
// MARK: - Functions
    
    func configure () {
        view.backgroundColor = .red
        view.addSubview(loginPageView)
        setupLoginPageView()
    }
    
    func setupLoginPageView () {
        loginPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

