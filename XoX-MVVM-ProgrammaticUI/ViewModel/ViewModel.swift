//
//  ViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 3.06.2023.
//

import Foundation
import Firebase

// MARK: - Protocol
protocol LoginPageViewDelegate: AnyObject {
    func loginButtonTapped(mail:String, password:String)
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, firstActionTitle: String?, secondActionTitle:String?, actionStyle: UIAlertAction.Style, handler: (() -> Void)?)
}

final class ViewModel {
    weak var delegate: LoginPageViewDelegate?
    
    func signIn(mail:String,password:String) {
        Auth.auth().signIn(withEmail: mail, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let error = error{
                strongSelf.delegate?.showAlert(title: "hop!", message: "there is no one", style: .alert, firstActionTitle: "create it", secondActionTitle:"never mind", actionStyle: .cancel, handler: {
                    print(123)
                })
            }
        }
    }
    
    func signUp(mail:String,password:String) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            
        }
    }
    
    
}
