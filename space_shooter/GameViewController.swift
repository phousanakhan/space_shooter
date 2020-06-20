//
//  GameViewController.swift
//  Space Shoot
//
//  Created by Phousanak Han on 08/05/20.
//  Copyright © 2020 Phousanak Han. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backingAudio = AVAudioPlayer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let filePath = Bundle.main.path(forResource: "back_sound", ofType: "mp3")
            let audioNSURL = NSURL(fileURLWithPath: filePath!)
            
            do {
                backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL)
            }
            catch {
                return print("Cannot find audio file")
            }
            
            backingAudio.numberOfLoops = -1
            backingAudio.volume = 0.5
            backingAudio.play()
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
