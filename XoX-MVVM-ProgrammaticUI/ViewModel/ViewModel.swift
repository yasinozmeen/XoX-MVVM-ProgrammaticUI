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
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, firstActionTitle: String?, secondActionTitle:String?, actionStyle: UIAlertAction.Style, handler: ((String?) -> Void)?)
}

final class ViewModel {
   
    weak var delegate: LoginPageViewDelegate?
    
    #warning("mail doğru ama şifre yanlış olabilir o zaman da yeni kullanıcı kurayım mı diye soruyor")
    
    func signIn(mail:String,password:String) {
        Auth.auth().signIn(withEmail: mail, password: password) { [weak self] authResult, error in
          guard let _ = self else { return }
            if let _ = error{
                self!.makeNoOneUserAlert(mail, password)
            }
        }
    }
    
    func signUp(mail:String,password:String) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            
        }
    }
    
    func makeNoOneUserAlert(_ mail:String, _ password:String){
        self.delegate?.showAlert(title: ConstantsLoginPageAlert.noOne.rawValue, message: ConstantsLoginPageAlert.doYouWantnewAccount.rawValue, style: .alert, firstActionTitle: ConstantsLoginPageAlert.create.rawValue, secondActionTitle:ConstantsLoginPageAlert.neverMind.rawValue, actionStyle: .cancel, handler: { title in
            
            if let title = title {
                if title == ConstantsLoginPageAlert.create.rawValue{
                    /// Create a New User
                    self.signUp(mail: mail, password: password)
                }else{
                    /// Close The App
                    print("AppClOSE")
                }
            }
        })
    }
}


