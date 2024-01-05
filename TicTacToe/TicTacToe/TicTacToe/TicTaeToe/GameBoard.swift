//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Vikas Salian on 05/01/24.
//

import Foundation

protocol GameBoardDelegate: AnyObject{
    func updateGame(gameState: GameStates)
}

enum GameStates{
    case invalidMove
    case matchDraw
    case matchEnded
    case playerWon(message: String)
    case playeMove(message: String)
    case resetGame
}

class GameBoard{
    
    var board = [[String]]()
    var boardSize: Int
    var players: [Player] = []
    var moveCount = 0
    var gameEnded: Bool = false
    
    weak var delegate: GameBoardDelegate?
    init(boardSize: Int,players: [Player],delegate: GameBoardDelegate?) {
        self.boardSize = boardSize
        self.delegate = delegate
        initialNewGame(players: players)
    }
    
    func initialNewGame(players: [Player]){
        self.board =  Array(repeating: Array(repeating: " ", count: boardSize), count: boardSize) // board
        self.players = players
    }
    
    func resetGame(players: [Player]){
        initialNewGame(players: players)
        gameEnded = false
        delegate?.updateGame(gameState: .resetGame)
        
    }
    
    func playMove(row: Int,column: Int){

        var gameState: GameStates = .invalidMove
        guard  board[row][column] == " " else {
            return
        }
        
        if gameEnded{
            gameState = .matchEnded
            return
        }
        
        let currentPlayer = players.removeFirst()
        
        defer{
            players.append(currentPlayer)
            delegate?.updateGame(gameState: gameState)
        }
        
        board[row][column] = currentPlayer.sign
        moveCount += 1
        
        if endOfGame(){
            gameState = .matchDraw
            return
        }else{
            gameState = .playeMove(message: "Player \(players.first?.sign ?? "") play the next move")

            if let playerSign  = checkForWinner(){
                gameState = .playerWon(message: "player with sign \(playerSign) as won")
                gameEnded = true
                return
            }
        }
        
    }
    
    func endOfGame() -> Bool {
        boardSize * boardSize  == moveCount
    }
    
    func checkForWinner() -> String?{
        for index in 0...boardSize - 1{
            if let playerSign = checkForRow(row: index){
                return playerSign
            }
            
            if let playerSign = checkForColumn(col: index){
                return playerSign
            }
        }
        
        if let playerSign =  downwardDiagonal(){
            return playerSign
        }
        if let playerSign = upwardDiagonal(){
            return playerSign
        }
        return nil
    }
    
    func checkForRow(row: Int) -> String?{
        
        let firstSign = board[row].first
        
        if firstSign == " "{
            return nil
        }
        
        for column in 0...boardSize-1{
            if board[row][column] != firstSign {
                return nil
            }
        }
        return firstSign
    }
    
    func checkForColumn(col: Int) -> String?{
        
        let firstSign = board.first?[col]
        
        if firstSign == " "{
            return nil
        }
        
        for row in 0...boardSize-1{
            if board[row][col] != firstSign {
                return nil
            }
        }
        return firstSign
    }
    
    func downwardDiagonal() -> String?{
        
        let firstSign = board.first?.first
        
        if firstSign == " "{
            return nil
        }

        for index  in 0...(boardSize-1){
            if  board[index][index] != firstSign {
                return nil
            }
        }
        
        return firstSign
    }
    
    
    func upwardDiagonal() -> String?{
        
        let firstSign = board.first?.last
        
        if firstSign == " "{
            return nil
        }

        for rowIndex  in 0...(boardSize-1){
            if  board[rowIndex][boardSize - 1 - rowIndex] != firstSign {
                return nil
            }
        }
        
        return firstSign
    }
    
}
