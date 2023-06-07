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
    func showAlert(title:String,
                   style: UIAlertController.Style,
                   actiontitle:String,
                   actionStyle:UIAlertAction.Style)
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
            "row":["0":" ","1":" ","2":" ","3":" ","4":" ","5":" ","6":" ","7":" ","8":" ",],
            "lastUser":currentUser ?? "Error",
            "whoWin":" "
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
                        self.changeButtonTitle(tag: tag)
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
                changeButtonTitle(tag: nil)
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
        isHeWon() {
            restartGame()
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
    
    func changeButtonTitle(tag:Int?) {
        if let gameData = gameData, let currentUser = currentUser {
            for data in gameData.row {
                if data.value != currentUser && data.value != " " {
                    delegate?.buttonTitleChange(title: ConstantsGame.O.rawValue, tag: data.key)
                }
                if data.value == currentUser {
                    delegate?.buttonTitleChange(title: ConstantsGame.X.rawValue, tag: data.key)
                    checkWinCondition { [self] bool in
                        if bool {
                         sendWinValue()
                            delegate?.showAlert(title:ConstantsGamePage.win.rawValue,
                                                style: .alert,
                                                actiontitle: ConstantsGamePage.ok.rawValue,
                                                actionStyle: .default)
                        }
                    }
                }
            }
        }
    }
    
// MARK: - Game Rules
    func checkWinCondition(handler: @escaping (Bool)->())  {
        if let gameData = gameData, let currentUser = currentUser {
            let winCombinations: [[Int]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9], // horizantal wins
                                            [1, 4, 7], [2, 5, 8], [3, 6, 9], // vertical wins
                                            [1, 5, 9], [3, 5, 7]] // cross wins
            
            for combination in winCombinations {
                let firstIndex = combination[0]
                let secondIndex = combination[1]
                let thirdIndex = combination[2]
                
                if gameData.row[firstIndex] == currentUser &&
                    gameData.row[secondIndex] == currentUser &&
                    gameData.row[thirdIndex] == currentUser {
                    handler(true)
                }
            }
            handler(false)
        }
        handler(false)
    }
    func sendWinValue() {
        if let currentUser = currentUser {
            fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).updateData([
                "whoWin":currentUser
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                }
            }
        }
    }
    func isHeWon(handler: ()->()) {
        if let whoWin = gameData?.whoWin, let currentUser = currentUser  {
            if whoWin != currentUser && whoWin != " "{
                delegate?.showAlert(title: ConstantsGamePage.lose.rawValue,
                                    style: .alert,
                                    actiontitle: ConstantsGamePage.ok.rawValue,
                                    actionStyle: .cancel)
            }
        }
    }
    func restartGame() {
        
    }
    
    func checkBoardIsFull(handler: @escaping (Bool)->()) {
        
    }
    
    
}
