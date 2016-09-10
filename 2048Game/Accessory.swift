//
//  Accessory.swift
//  2048Game
//
//  Created by Sunny on 2016/9/10.
//  Copyright © 2016年 Sunny. All rights reserved.
//

import UIKit
protocol ScoreViewProtocol{
    func scoreChanged(newScore s:Int)
}

class ScoreView: UIView, ScoreViewProtocol{
    var score: Int = 0 {
        didSet{
            label.text = "SCORE: \(score)"
        }
    }
    let defaultFrame = CGRectMake(0, 0, 140, 140)
    var label: UILabel
    
    init(backgroundColor bgcolor: UIColor, textColor tcolor: UIColor, font: UIFont, radius r: CGFloat){
        label = UILabel(frame: defaultFrame)
        label.textAlignment = NSTextAlignment.Center
        super.init(frame: defaultFrame)
        
        backgroundColor = bgcolor
        label.textColor = tcolor
        label.font = font
        
        layer.cornerRadius = r
        self.addSubview(label)
    }
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoding not supported")
    }
    func scoreChanged(newScore s: Int) {
        let defaultFrame = CGRectMake(0, 0, 140, 140)
    }
    
}
