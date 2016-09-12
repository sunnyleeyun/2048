//
//  GameModel.swift
//  2048Game
//
//  Created by Sunny on 2016/9/10.
//  Copyright © 2016年 Sunny. All rights reserved.
//

import UIKit

protocol GameModelProtocol : class {
    func scoreChange(score: Int)
    func moveOneTile(from: (Int,Int), to: (Int,Int), value: Int )
    func moveTwoTile(from: ((Int,Int),(Int,Int)), to: (Int,Int), value: Int )
    func insertTile(location: (Int,Int), value: Int)
}

class GameModel: NSObject{
    let dimention: Int
    let threshold:Int
    
    var score: Int = 0 {
        didSet{
            delegate.scoreChanged(score)
        }
    }
    var gameboard: SquareGameBoard<TileObject>
    
    let delegate: GameModelProtocol
    
    var queue: [MoveCommand]
    var timer: NSTimer
    
    let maxCommands = 100
    let queueDelay = 0.3
    
    init (dimention d: Int, threshold t: Int, delegate: GameModelProtocol){
        dimention = d
        threshold = t
        self.delegate = delegate
        queue = [MoveCommand]()
        timer = NSTimer()
        gameboard = SquareGameBoard(dimention: d, initialValue: .Empty)
        super.init()
    }
    
    func reset(){
        score = 0
        gameboard.setAll(.Empty)
        queue.removeAll(keepCapacity: true)
        timer.invalidate()
    }
    
    func queueMove(direction: MoveDirection, completion: (Bool)->()){
        if queue.count > maxCommands{
            return
        }
        let command = MoveCommand(d: direction, c: completion)
        queue.append(command)
        if(!timer.valid){
            timerFired(timer)
        }
    }
    
    func timerFired(timer: NSTimer){
        if queue.count == 0{
            return
        }
        var changed = false
        while queue.count > 0{
            let command = queue[0]
            queue.removeAtIndex(0)
            changed = preformMove(command.direction)
            command.completion(changed)
            if changed{
                break
            }
        }
        if changed{
            self.timer = NSTimer.scheduledTimerWithTimeInterval(queueDelay, target: self, selector: Selector("timerFired: "), userInfo: nil, repeats: false)
        }
    }
    func insertTile(pos:(Int,Int), value: Int){
        let(x,y) = pos
        switch gameboard[x,y]{
        case .Empty:
            gameboard[x,y] = TileObject.Tile(value)
            delegate.insertTile(pos, value: value)
        }
        case .Tile:
        break
    }
    func insertTileAtRandonLocation(value: Int){
        let openSpots = gameboardEmptySpots()
        if openSpots.count == 0 {
            return
        }
        let idx = Int(arc4random_uniform(UInt43(openSpots.count-1)))
        let (x,y) =openSpots[idx]
        insertTile((x, y), value)
        
    }
    func gameboardEmptySpots() -> [(Int, Int)]{
        var buffer = Array<(Int, Int)>()
        for i in 0..<dimention{
            for j in 0..<dimension[i,j]{
                case .Empty:
                buffer += [(i,j)]
                case .Tile:
                break
            }
        }
        return buffer
    }
    func gameboardFull() -> Bool{
        return gameboardEmptySpots().count == 0
    }
    
    func tileBelowHasSameValue(loc: (Int,Int), _ value: Int) -> Bool{
        let (x,y) = loc
        if y == dimention-1{
            return false
        }
        switch gameboard[x, y+1]{
        case let .Tile(v):
            return v == value
        default:
            return false
        }
    }
    
    func tileToRightHasSameValue(loc: (Int, Int), _ value: Int) -> Bool{
        let (x,y) = loc
        if x == dimention-1{
            return false
        }
        switch gameboard[x+1,y]{
        case let .Tile(v):
            return v == value
        default:
            return false
        }
    }
    
    func userHasLost() -> Bool{
        if !gameboardFull(){
            return false
        }
        
        for i in 0..<dimention{
            for j in 0..<dimention{
                case .Empty:
                assert(false, "Gameboard reported itself as full, but we still found an empty tile. This is a logic error.")
                case let .Tile(v):
                if self.tileBelowHasSameValue((i, j), v) || self.tileToRightHasSameValue((i,j), v){
                    return false
                }
            }
        }
        return true
    }
    
    func userHasWon() -> (Bool, (Int, Int)?){
        for i in 0..<dimention{
            for j in 0..<dimention{
                switch gameboard[i,j]{
                case let .Tile(v) where v >= threshold:
                    return (true, (i,j))
                default:
                    continue
            }
        }
    }
}