//
//  ExtensionGameSceneViewController.swift
//  Match3
//
//  Created by Andrey on 12.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
extension GameSceneViewController{
    
    func setupDefaultSetting(){
        self.registerCell(identifier: GameSceneCollectionViewCell.identifier)
        self.completionManagerGame()
        ManagerGame.sharedInstance.setupRowsAndColumns(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        ManagerGame.sharedInstance.startGame()
    }
    
    func completionManagerGame(){
        ManagerGame.sharedInstance.completionHandler = {(isTime,isRefresh)->Void in
            if isTime {self.updateUITime()}
            if isRefresh {self.refresh()}
        }
    }
    
    func startDetectMatches(){
        ManagerGame.sharedInstance.startDetectMatches {
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
                self.collectionView.reloadWithoutAnimation()
                self.updateUIScore()
                self.startDetectMatches()
                AudioPlayer.sharedInstance.setMusic(nameSound: Sounds.drip, type: Sounds.Types.wav, loop: 0)
            })
        }
    }
    
    func clickAction(indexPath:IndexPath){
        ManagerGame.sharedInstance.startSwapModelCell(index: indexPath.row) { () in
            self.startDetectMatches()
        }
    }
    
    func refresh(){
        self.collectionView.reloadWithoutAnimation()
        self.startDetectMatches()
    }
    
    private func updateUITime(){
        self.timeLabel.text = "Time:" + " " + String(ManagerGame.sharedInstance.time)
    }
    
    private func updateUIScore(){
        self.scoreLabel.text = String(ManagerGame.sharedInstance.score)
    }
    
    private func registerCell(identifier:String){
        let nib = UINib(nibName: identifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

//MARK:- UICollectionViewDataSourse and Delegate

extension GameSceneViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ManagerGame.sharedInstance.modelCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameSceneCollectionViewCell.identifier, for: indexPath) as! GameSceneCollectionViewCell
        let modelCell = ManagerGame.sharedInstance.modelCells[indexPath.row]
        cell.modelCell = modelCell
        return cell
    }
    
    ///MARK:- UICollectionDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clickAction(indexPath: indexPath)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return GameSceneCollectionViewCell.sizeItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left:0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
