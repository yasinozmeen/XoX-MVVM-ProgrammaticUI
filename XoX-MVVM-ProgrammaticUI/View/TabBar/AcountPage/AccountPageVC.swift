//
//  AccountPageVC.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit

final class AccountPageVC: UIViewController {

// MARK: - Properties
    let accountPageView = AccountPageView()
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        accountPageView.configure()
    }
    
// MARK: - Functions
    private func configure () {
        view.backgroundColor = .red
        view.addSubview(accountPageView)
        setupAccountPageView()
    }
    
    private func setupAccountPageView () {
        accountPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
     
}
