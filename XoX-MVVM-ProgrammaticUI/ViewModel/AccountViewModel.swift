//
//  AccounViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 4.06.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Protocol that facilitates communication between AccountPageVC and AccountViewModel.
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
    /// The function called when the "signOut" button is clicked. After that, the saveUserOffline and restartApplication functions are called
    func singOut(){
        lastUserMail = firebaseAuth.currentUser?.email
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            #warning("error handling")
        }
        saveUserOfline {
            self.restartApplication()
        }
    }
    
    /// Taking the email information from the lastUserMail variable, the user is saved offline in Firebase Firestore. This is done using the following function
    /// - Parameter handler: Once the operation is completed, it can be used to call the new function
    func saveUserOfline(handler:  ()->()){
        if let mail = lastUserMail{
            fireBaseDataBase.collection("User").document(mail).setData([
                "is online":false
            ]) { err in
#warning("error handling")
            }
            handler()
        }
    }
    
    /// A function that sends the user to the loginPageVC screen.
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


