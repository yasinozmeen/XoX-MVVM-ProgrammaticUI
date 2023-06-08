//
//  GameViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 4.06.2023.
//

import Foundation
import Firebase

/// Documentation for accessing the viewModel from the GamePageView and GamePageVC pages.
protocol GameProtocol: AnyObject {
    
    /// The protocol used to call the necessary function from the viewModel when a button is tapped.
    /// - Parameter tag: The tag value of the tapped button.
    func buttonDidTappedP(tag:Int)
    
    /// The protocol used to change the text of the turn label.
    /// - Parameter turnIs: The variable that determines whose turn it is:
    func changeTurnLabelP(turnIs:String)
    
    /// The protocol used to change the text value of the clicked button.
    /// - Parameters:
    ///   - title: The parameter where we input what will be written on the button.
    ///   - tag: The parameter that specifies the tag value of the clicked button.
    func buttonTitleChange(title: String, tag: Int)
    
    /// The protocol used to display an alert on the screen.
    /// - Parameters:
    ///   - title: The parameter that will be displayed as the title of the alert.
    ///   - style: The style of the alert.
    ///   - actiontitle: The parameter that specifies what will be written in the action of the alert.
    ///   - actionStyle: The style of the action.
    func showAlert(title:String,
                   style: UIAlertController.Style,
                   actiontitle:String,
                   actionStyle:UIAlertAction.Style)
    
    /// The protocol that resets the text values of all buttons.
    func restartBoard()
}

class GameViewModel {
    // MARK: - Properties
    var delegate: GameProtocol?
    let fireBaseDataBase = Firestore.firestore()
    var currentUser: String?
    var onlineUsers: [String?] = []
    var matchUsers: [String] = []
    var gameData: GameModel?
    // MARK: - Functions
    
    /// The function that retrieves the current user from Firebase Auth. If the operation is successful, we assign the retrieved information to the currentUser variable. After the operation is completed, we call the waitOnlineUser function
    func getCurrentUser() {
        if let currentUser = Auth.auth().currentUser  {
            self.currentUser = currentUser.email
        }
        waitOnlineUser()
    }
    
    /// A function that retrieves online users from Firebase Firestore and assigns them to the onlineUser variable. At the end of the function, if the number of online users is 2, the matchUser function is run.
    private func waitOnlineUser() {
        fireBaseDataBase.collection("User").whereField("is online", isEqualTo: true)
            .addSnapshotListener { [self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print(error?.localizedDescription as Any)
                    return
                }
                self.onlineUsers = []
                for i in documents {
                    self.onlineUsers.append(i.documentID)
                }
                if onlineUsers.count == 2{
                    matchUser()
                }
            }
    }
    
    /// It assigns online users to the matchUser variable and calls the createGameCollection function.
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
    
    /// In Firebase Firestore, it creates a new game document by combining the email addresses of matched users.
    /// - Parameter handler: After the function has finished running, it is used to call the FetchGameData function.
    private func createGameCollection(handler: @escaping ()->()) {
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).setData([
            "row":["0":" ","1":" ","2":" ","3":" ","4":" ","5":" ","6":" ","7":" ","8":" ",],
            "lastUser":currentUser ?? "Error",
            "whoWin":" "
        ]) { err in
            print(err?.localizedDescription as Any)
        }
        handler()
    }

    
    /// A function called with the help of a delegate when the button is clicked. Firstly, the FetchGameData() function is called. Then in order, the checkIsItYourTurn function is called and within its handler the checkPlayIsTrue function is called, and within its handler, the sendgameValue and changeButton title functions are called.
    /// - Parameter tag: The value of the button clicked by the user.
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
    
    /// It pulls game data from Firebase Firestore.Then it calls the saceDataModel, changeButtonTitle, changeTurnLabel, and checkBoardIsFull functions.
    private func fetchGameData() {
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1])
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print(error?.localizedDescription as Any)
                    return
                }
                guard let data = document.data() else {
                    return
                }
                saveDataToModel(data: data)
                changeButtonTitle(tag: nil)
                changeTurnLabel()
                checkBoardIsFull { bool in
                    if bool {
                        self.delegate?.showAlert(title: ConstantsGamePage.tied.rawValue,
                                            style: .alert,
                                            actiontitle: ConstantsGamePage.ok.rawValue,
                                            actionStyle: .cancel)
                    }
                }
            }
    }
    
    /// It assigns the data given as a data parameter to the gameData variable of type GameDataModel.
    /// - Parameter data: The data to be parsed into GameModel type and assigned to the gameData variable.
    private func saveDataToModel(data: [String:Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            gameData = try JSONDecoder().decode(GameModel.self, from: jsonData)
        } catch {
            print("Hata: \(error)")
        }
        isHeWon()
    }
    
    /// It checks whether it is the user's turn or not.
    /// - Parameters:
    ///   - currentUser: The active user on Firebase Auth.
    ///   - handler: It sends the value being checked as a boolean type.
    private func checkIsItYourTurn(currentUser:String?, handler: @escaping (Bool)->()) {
        if let gameData = gameData {
            if currentUser == gameData.lastUser {
                /// not your turn
                handler(false)
            }else{
                /// your turn
                handler(true)
            }
        }
    }
    /// It checks whether the button clicked by the user is empty or not.
    /// - Parameters:
    ///   - tag: Tag value of clicked button
    ///   - handler: It sends the check value as a boolean.
    private func checkPlayIsTrue(tag:Int, handler: @escaping (Bool)->()) {
        if let value = gameData?.row[tag]{
            if value == " " {
                handler(true)
            }else{
                handler(false)
            }
        }
    }
    
    /// It sends the user's most recent change to the active game document in Firebase Firestore and assigns the last user as the user who made the change.
    /// - Parameter tag: Tag value of clicked button
    private func sendGameValue(tag: Int) {
        fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).updateData([
            "row.\(tag)": currentUser ?? "error",
            "lastUser":currentUser ?? "Error"
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
        changeTurnLabel()
    }
    
    /// It updates the text of TurnLabel by getting help from the checkItIsYourTurn function.
    func changeTurnLabel(){
        checkIsItYourTurn(currentUser: currentUser) { [self] bool in
            if bool {
                delegate?.changeTurnLabelP(turnIs: "turn: " + ConstantsGame.X.rawValue)
            }else{
                delegate?.changeTurnLabelP(turnIs: "turn: " + ConstantsGame.O.rawValue)
            }
        }
    }
    
    /// It updates the button clicked by the user as X or O with the help of currentUser and gameData variables.
    /// - Parameter tag: Tag value of clicked button
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
    /// It checks if there is a winner in the game by accessing the text information of the buttons.
    /// - Parameter handler: It sends the check value.
    func checkWinCondition(handler: @escaping (Bool)->())  {
        if let gameData = gameData, let currentUser = currentUser {
            let winCombinations: [[Int]] = [[0, 1, 2], [3, 4, 5], [6, 7, 8], // yatay kazanmalar
                                                    [0, 3, 6], [1, 4, 7], [2, 5, 8], // dikey kazanmalar
                                                    [0, 4, 8], [2, 4, 6]] // çapraz kazanmalar
            
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
    
    /// It sends the winner's information to Firestore.
    func sendWinValue() {
        if let currentUser = currentUser {
            fireBaseDataBase.collection("Game").document(matchUsers[0]+matchUsers[1]).updateData([
                "whoWin":currentUser
            ]) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                }
            }
            
        }
    }
    
    /// It checks whether the opposing player has won or not. If they have won, it shows an alert on the screen.
    func isHeWon() {
        if let whoWin = gameData?.whoWin, let currentUser = currentUser  {
            if whoWin != currentUser && whoWin != " "{
                delegate?.showAlert(title: ConstantsGamePage.lose.rawValue,
                                    style: .alert,
                                    actiontitle: ConstantsGamePage.ok.rawValue,
                                    actionStyle: .cancel)
            }
        }
    }
    
    /// It checks whether all the buttons on the game board have been clicked or not.
    /// - Parameter handler: It sends the check value.
    func checkBoardIsFull(handler: @escaping (Bool)->()) {
        if let gameData = gameData {
             let isFull = gameData.row.values.allSatisfy ({ $0 != " " })
             handler(isFull)
         } else {
             handler(false)
         }
    }
    
    /// It equates the gameData variable to nil and calls the signOut function from AccountViewModel.
    func restartGame() {
        gameData?.whoWin = nil
        do{
            try AccountViewModel().singOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
