//
//  AccounViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 4.06.2023.
//

import Foundation
import Firebase

protocol AccountDelegate: AnyObject {
    func signOutButtonTapped()
}

final class AccountViewModel {
    // MARK: - Preperties
    weak var delegate: AccountDelegate?
    let fireBaseDataBase = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    public var lastUserMail: String?
    
    // MARK: - Functions
    func singOut(){
        lastUserMail = firebaseAuth.currentUser?.email
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        saveUserOfline {
            self.restartApplication()
        }
    }
    
    func saveUserOfline(handler:  ()->()){
        if let mail = lastUserMail{
            fireBaseDataBase.collection("User").document(mail).setData([
                "is online":false
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                }
            }
            handler()
        }
    }
    
    func restartApplication () {
        let viewController = LoginPageVC()
        let navCtrl = UINavigationController(rootViewController: viewController)
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
        else {
            return
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
    }
    
}


