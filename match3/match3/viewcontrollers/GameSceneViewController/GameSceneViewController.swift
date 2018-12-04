//
//  MainViewController.swift
//  Match3
//
//  Created by Andrey on 12.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class GameSceneViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet var improvementButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupDefaultSetting()
        self.startDetectMatches()
        AudioPlayer.sharedInstance.setMusicFon(nameSound: Sounds.musicFon, type: Sounds.Types.mp3, loop: -1)
    }
    @IBAction func improvementAction(_ sender: UIButton) {
        ManagerGame.sharedInstance.improvementAction(tag: sender.tag)
    }
}
