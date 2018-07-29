//
//  ViewController.swift
//  swiftyprac
//
//  Created by Christopher Norman on 8/18/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class camController: UIViewController {
   
    let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        return button
    }()
    
    @objc func playVideo(_ sender: AnyObject) {
        guard let url = URL(string: "https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8") else {
            return
        }
        
        let player = AVPlayer(url: url)
        
        let controller = AVPlayerViewController()
        controller.player = player
        
        present(controller, animated: true) {
            player.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.center = self.view.center
    }

}

