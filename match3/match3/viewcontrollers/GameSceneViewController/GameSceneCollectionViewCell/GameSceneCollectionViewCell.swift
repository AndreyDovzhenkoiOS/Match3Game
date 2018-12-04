//
//  MainCollectionViewCell.swift
//  Match3
//
//  Created by Andrey on 12.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
final class GameSceneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView:UIImageView!
    
    static let identifier = "GameSceneCollectionViewCell"
    static let sizeItem = CGSize(width: 50, height: 50)
    
    var modelCell:ModelCell?{
        didSet{self.updateUI()}
    }
    
    override func awakeFromNib() {
        self.allNotification()
    }
    
    private func updateUI(){
        self.imageView.image = self.getImage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
