//
//  GameViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 4.06.2023.
//

import Foundation
import Firebase

protocol GameProtocol: AnyObject {
    func buttonDidTappedP(tag:Int)
    func changeTurnLabelP(turnIs:String)
    func buttonTitleChange(title: String, tag: Int)
}

class GameViewModel {
    // MARK: - Properties
    var delegate: GameProtocol?
    let fireBaseDataBase = Firestore.firestore()
    var currentUser: String?
    var onlineUsers: [String?] = []
    var matchUsers: [String] = []
    var gameData: GameModel?
    var lastGameData: GameModel?
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
        createGameCollection { [self] in
            fetchGameData()
        }
    }
    
    private func createGameCollection(handler: @escaping ()->()) {
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).setData([
            "row":["1":" ","2":" ","3":" ","4":" ","5":" ","6":" ","7":" ","8":" ","9":" ",],
            "lastUser":currentUser ?? "Error"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
            }
        }
        handler()
    }
    
    func buttonDidTapped(tag: Int) {
        fetchGameData()
        checkIsItYourTurn(currentUser: currentUser) { bool in
            if bool {
                self.checkPlayIsTrue(tag: tag) { bool in
                    if bool {
                        self.sendGameValue(tag: tag)
                    }
                }
            }
        }
    }
    
    private func fetchGameData() {
        fireBaseDataBase.collection("Game").document("yasinozmeen2@gmail.comyasinozmeen3@gmail.com")
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                saveDataToModel(data: data)
                changeTurnLabel()
            }
    }
    
    private func saveDataToModel(data: [String:Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            lastGameData = gameData
            gameData = try JSONDecoder().decode(GameModel.self, from: jsonData)
        } catch {
            print("Hata: \(error)")
        }
    }
    
    private func checkIsItYourTurn(currentUser:String?, handler: @escaping (Bool)->()) {
        if currentUser == gameData!.lastUser {
            /// not your turn
            handler(false)
        }else{
            /// your turn
            handler(true)
        }
    }
    private func checkPlayIsTrue(tag:Int, handler: @escaping (Bool)->()) {
        if let value = gameData?.row[tag]{
            if value == " " {
                handler(true)
            }else{
                handler(false)
            }
        }
    }
    
    private func sendGameValue(tag: Int) {
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).updateData([
            "row.\(tag)": currentUser ?? "error",
            "lastUser":currentUser ?? "Error"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
            }
        }
        changeTurnLabel()
    }
    
    func changeTurnLabel(){
        checkIsItYourTurn(currentUser: currentUser) { [self] bool in
            if bool {
                delegate?.changeTurnLabelP(turnIs: "turn: " + ConstantsGame.X.rawValue)
            }else{
                delegate?.changeTurnLabelP(turnIs: "turn: " + ConstantsGame.O.rawValue)
            }
            
        }
        
    }
    
    func changeButtonTitle(tag:Int?, meOrHe:Bool) {
       
    }
    
   
    
}
