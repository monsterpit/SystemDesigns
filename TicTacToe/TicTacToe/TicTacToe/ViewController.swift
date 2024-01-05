//
//  ViewController.swift
//  TicTacToe
//
//  Created by Vikas Salian on 05/01/24.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var gameStateLabel: UILabel!
    
    private var minimumSpacing: CGFloat = 5
    private var padding: CGFloat = 20
    lazy var edgeInsetPadding: CGFloat =  {
        padding + padding
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var gameBoard: GameBoard = {
        let player1 = Player(name: "Vikas", sing: "X")
        let player2 = Player(name: "Bot", sing: "O")
        
        let players = [player1,player2]
        let gameBoard =  GameBoard(boardSize: 3, players: players, delegate: self)
        return gameBoard
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "TiCTacToeCell", bundle: nil), forCellWithReuseIdentifier: "TiCTacToeCell")
        
    }


    @IBAction func handleButtonPress(_ sender: UIButton) {
        let player1 = Player(name: "Vikas", sing: "X")
        let player2 = Player(name: "Bot", sing: "O")
        let players = [player1,player2]
       
        gameBoard.resetGame(players: players)
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameBoard.boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        gameBoard.boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TiCTacToeCell", for: indexPath) as! TiCTacToeCell
        cell.label.text = gameBoard.board[indexPath.row][indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Int(UIScreen.main.bounds.size.width) - ((gameBoard.boardSize - 1) * (Int(minimumSpacing) + Int(edgeInsetPadding)))) / gameBoard.boardSize
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameBoard.playMove(row: indexPath.row, column: indexPath.section)
    }
    
}

extension ViewController: GameBoardDelegate{
    func updateGame(gameState: GameStates) {
        switch gameState{
        case .invalidMove:
            gameStateLabel.text = "Invalid Move please select again"
        case .matchDraw:
            gameStateLabel.text = "Match Draw"
        case .matchEnded:
            gameStateLabel.text = "Match Already Ended"
        case .playerWon(let message):
            gameStateLabel.text = message
        case .playeMove(let message):
            gameStateLabel.text = message
        case .resetGame:
            gameStateLabel.text = "Start the Game"
        }
        collectionView.reloadData()
    }
    
    
}
