//
//  GamePageVC.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit.UIViewController
import SnapKit

final class GamePageVC: UIViewController {
    // MARK: - Properties
    let gamePageView = GamePageView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        gamePageView.configure()
    }
    
    // MARK: - Functions
    func configure () {
        view.backgroundColor = .red
        view.addSubview(gamePageView)
        setupGamePageView()
    }
    
    func setupGamePageView () {
        
    }
}
