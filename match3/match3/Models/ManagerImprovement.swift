//
//  ManagerImprovement.swift
//  Match3
//
//  Created by Andrey on 24.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ManagerImprovement: NSObject {
    static let sharedInstance = ManagerImprovement()
    
    //MARK: - Property
    
    var isScoringImprovement = false
    var isSameModelCellHideImprovement = false
    var isChangeModelCellImprovement = false
    
    var modelCellForChangeImprovement:ModelCell!
    
    //Setting
    
    private let stoppingTime = 5.0
    
    //MARK: - Functions
    
    public func sameModelCellHideImprovement(modelCell:ModelCell){
        if self.isSameModelCellHideImprovement{
            for valueModelCell in ManagerGame.sharedInstance.modelCells {
                if valueModelCell.type == modelCell.type{
                    ManagerDetectMatches.sharedInstance.modelCellMatches.append(valueModelCell)
                }
            }
            ManagerSwapModelCell.sharedInstance.resetSwapModelCell()
            self.isSameModelCellHideImprovement = false
        }
    }
    
    public func scoring(increaseScore:Int){
        if self.isScoringImprovement {
            ManagerGame.sharedInstance.score *= increaseScore
            self.isScoringImprovement = false
        }
    }
    
    public func stopTimeTimer(){
        ManagerGame.sharedInstance.timeTimer?.invalidate()
        Timer.scheduledTimer(withTimeInterval: self.stoppingTime, repeats: false) { (timer) in
            ManagerGame.sharedInstance.startTimer()
        }
    }
    
    public func refreshModelCell(){
        ManagerGame.sharedInstance.fillModelCell()
        AudioPlayer.sharedInstance.setMusic(nameSound: Sounds.refresh, type: Sounds.Types.wav, loop: 0)
        ManagerGame.sharedInstance.completionHandler(false,true)
    }
    
    //MARK:- ChangeModelCellImprovement
    
    public  func changeModelCellImprovement(index:Int){
        self.setupRememberModelCell(index: index) {
            if !self.checkResetChangeModelCellImprovement(index: index){
                self.changeTypeForModelCell()
            }
        }
    }
    
    public func resetChangeImprovement(isReset:Bool){
        if self.modelCellForChangeImprovement != nil && isReset{
            self.modelCellForChangeImprovement.click = false
            self.updateCell(notificationName: Notifications.notificationNameSwap, object: self.modelCellForChangeImprovement)
            self.modelCellForChangeImprovement = nil
            self.isChangeModelCellImprovement = false
        }
    }
    
    private func setupRememberModelCell(index:Int,completion:@escaping()->Void){
        if self.modelCellForChangeImprovement == nil{
            self.modelCellForChangeImprovement = ManagerGame.sharedInstance.modelCells[index]
            self.modelCellForChangeImprovement.click = true
        }
        completion()
    }
    
    private func checkResetChangeModelCellImprovement(index:Int)->Bool{
        let newModelCell = ManagerGame.sharedInstance.modelCells[index]
        if self.modelCellForChangeImprovement != newModelCell{
            self.resetChangeImprovement(isReset: true)
            return true
        }
        return false
    }
    
    private func changeTypeForModelCell(){
        self.modelCellForChangeImprovement.type = ManagerGame.sharedInstance.getRandomType()
        self.updateCell(notificationName: Notifications.notificationNameSwap, object: self.modelCellForChangeImprovement)
    }
}
