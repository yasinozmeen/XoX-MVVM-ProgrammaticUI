//
//  GamePageView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit
import SnapKit

class GamePageView : UIView {
    // MARK: - UI Elements
    private let isTurn: UILabel = {
        let label = UILabel()
        label.text = ConstantsGamePage.turn.rawValue
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    private let horizantalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        stackView.backgroundColor = .label
        return stackView
    }()
    

// MARK: - Function
    func setupVerticalStackViewsAndButtons (){
        for x in 1...3{
            
            let verticalStackView: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.distribution = .fillEqually
                stackView.spacing = 3
                return stackView
            }()
            horizantalStackView.addArrangedSubview(verticalStackView)
            
            for y in 1...3{
                    
                let xoButton: UIButton = {
                    let button = UIButton()
                    button.setTitle("X", for: .normal)
                    button.setTitleColor(.label, for: .normal)
                    button.titleLabel?.font = UIFont(name: "Helvetica", size: 35)
                    button.backgroundColor = .systemGray6
                    button.isUserInteractionEnabled = true
                    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                    return button
                }()
                
                xoButton.restorationIdentifier = String(y)+String(x)
                verticalStackView.addArrangedSubview(xoButton)
            }
        }
    }
    
    func configure() {
        self.backgroundColor = .systemGray6
        setupIsTurn()
        setupHorizantalStackView()
        setupVerticalStackViewsAndButtons()
        
    }
    
    // MARK: - Targets
    
    @objc func buttonTapped(_ sender: UIButton) {
        print(sender.restorationIdentifier)
    }
}

extension GamePageView {
    
    func setupIsTurn() {
        addSubview(isTurn)
        
        isTurn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.1184834123)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupHorizantalStackView() {
        addSubview(horizantalStackView)
        
        horizantalStackView.snp.makeConstraints { make in
            make.top.equalTo(isTurn.snp.bottom).offset(UIScreen.main.bounds.height * 0.15)
            make.width.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
    }
}
