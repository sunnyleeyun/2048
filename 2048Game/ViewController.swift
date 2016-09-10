//
//  ViewController.swift
//  2048Game
//
//  Created by Sunny on 2016/9/10.
//  Copyright © 2016年 Sunny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func startGameButtonTapped(sender: UIButton){
        let game = GameViewController(dimention: 8, threshold: 2048)
        self.presentViewController(game, animated: true, completion: nil)
        
    }
}

