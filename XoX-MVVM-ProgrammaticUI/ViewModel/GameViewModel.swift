//
//  GameViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 4.06.2023.
//

import Foundation
import Firebase

protocol GameProtocol: AnyObject {
    func buttonDidTapped(tag: Int)
}

final class GameViewModel {    
// MARK: - Properties
    weak var delegate: GameProtocol?
    let fireBaseDataBase = Firestore.firestore()
    var currentUser: String?
    var onlineUsers: [String?] = []
    var matchUsers: [String] = []
    
// MARK: - Functions
    
    func getCurrentUser() {
            if let currentUser = Auth.auth().currentUser  {
                self.currentUser = currentUser.email
            }
            waitOnlineUser()
        }
    private func waitOnlineUser() {
        fireBaseDataBase.collection("User").whereField("is online", isEqualTo: true)
            .addSnapshotListener { [self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {print("Error fetching documents: \(error!)");return}
                let users = documents
                self.onlineUsers = []
                for i in users {
                    self.onlineUsers.append(i.documentID)
                }
                if onlineUsers.count == 2{
                    matchUser()
                }
            }
    }
    private func matchUser() {
        for user in onlineUsers{
            if let user = user {
                matchUsers.append(user)
            }
        }
        createGameCollection()
    }
    private func createGameCollection() {
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).setData([
                "row":[0,0,0,0,0,0,0,0],
            "lastUser":currentUser ?? "Error"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
            }
        }
    }
    
    func didPlay(tag:Int) {
        let row = "row.\(tag)"
        
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).updateData([
            row: 1,
            "lastUser":currentUser ?? "Error"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
            }
        }
    }
}
