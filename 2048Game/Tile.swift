 //
//  Tile.swift
//  2048Game
//
//  Created by Sunny on 2016/9/10.
//  Copyright © 2016年 Sunny. All rights reserved.
//

 import UIKit
 
 class Tile: UIView{
    var delegate: AppearanceProtocol
    var value: Int = 0{
        didSet {
            backgroundColor = delegate.tileColor(value)
            numberLabel.textColor = delegate.numberColor(value)
            numberLabel.text = "\(value)"
        }
    }
    var numberLabel: UILabel
    required init(code: NSCoder){
        fatalError("NSCoding not supported")
    }
    
    init(position: CGPoint, width: CGFloat, value: Int, radius: CGFloat, delegate d: AppearanceProtocol){
        addSubview(numberLabel)
        layer.cornerRadius = radius
        
        self.value = value
        backgroundColor = delegate.tileColor(value)
        numberLabel.textColor = delegate.numberColor(value)
        numberLabel.text = "\(value)"
    }
    
 }
