//
//  ManagerSwipeModelCell.swift
//  Match3
//
//  Created by Andrey on 13.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ManagerSwapModelCell: NSObject {
    static let sharedInstance = ManagerSwapModelCell()
    
    //MARK: - Property
    
    private var modelCells = [ModelCell]()
    private var modelCellFromSwapFirst:ModelCell?
    private var modelCellFromSwapSecond:ModelCell?
    
    //MARK: - Functions
    
    public func setupSwapModelCell(index:Int,modelCells:[ModelCell],completion:@escaping()->Void){
        self.modelCells = modelCells
        self.setupRememberSwapModelCell(index: index)
        self.changeModelCell()
        if self.isAccessSwapModelCell() {
            self.swapModelCell()
        }
        completion()
    }
    
    public  func resetSwapModelCell(){
        self.setClickForModelCellSwap(isClick: false)
        self.modelCellFromSwapFirst = nil
        self.modelCellFromSwapSecond = nil
    }
    
    private func setupRememberSwapModelCell(index:Int){
        if self.modelCellFromSwapFirst == nil {
            self.modelCellFromSwapFirst = self.modelCells[index]
            self.setClickForModelCellSwap(isClick: true)
        }else if self.modelCellFromSwapSecond == nil  {
            self.modelCellFromSwapSecond = self.modelCells[index]
        }
    }
    
    private func setClickForModelCellSwap(isClick:Bool){
        self.modelCellFromSwapFirst?.click = isClick
        self.updateCell(notificationName: Notifications.notificationNameSwap, object: self.modelCellFromSwapFirst)
    }
    
    private func changeModelCell(){
        let isSameModelCell = self.modelCellFromSwapFirst == self.modelCellFromSwapSecond
        if isSameModelCell{self.resetSwapModelCell()}
    }
    
    private func isAccessSwapModelCell()->Bool{
        if self.isStateModelCell() {
            let checkСalculationSwapModelCell = self.checkСalculationSwapModelCell()
            if !checkСalculationSwapModelCell{
                self.modelCellFromSwapSecond = nil
            }
            self.playSound(isRightChoice: checkСalculationSwapModelCell)
            return checkСalculationSwapModelCell
        }
        return false
    }
    
    private func checkСalculationSwapModelCell()->Bool{
        var success = false
        
        let dataModelCell = self.getDataFromSwapModelCell()
        
        let isMatch = self.checkMatch()
        let same = self.modelCellFromSwapFirst?.type == self.modelCellFromSwapSecond?.type
        
        let leftOrRight = dataModelCell.rowFirst == dataModelCell.rowSecond && (dataModelCell.columnSecond + 1 == dataModelCell.columnFirst || dataModelCell.rowFirst == dataModelCell.rowSecond && dataModelCell.columnSecond - 1 == dataModelCell.columnFirst) && !same
        
        let up = dataModelCell.rowSecond + 1 == dataModelCell.rowFirst && dataModelCell.columnSecond == dataModelCell.columnFirst && !same
        
        let down = dataModelCell.rowSecond - 1 == dataModelCell.rowFirst && dataModelCell.columnSecond == dataModelCell.columnFirst && !same
        
        if (leftOrRight || up || down) && isMatch{
            success = true
        }else{
            ManagerImprovement.sharedInstance.isScoringImprovement = false
        }
        return success
    }
    
    private func checkMatch()->Bool {
        let modelCellMathesForChecking = self.getModelCellMathesForChecking()
        let success = ManagerDetectMatches.sharedInstance.checkingMatch(modelCells:modelCellMathesForChecking)
        if success {ManagerDetectMatches.sharedInstance.modelCellMatches.removeAll()}
        return success
    }
    
    private func getModelCellMathesForChecking()->[ModelCell]{
        var modelCellMathesForChecking = self.modelCells
        let indexOfObjectFirst = self.modelCells.index(where:{$0 == self.modelCellFromSwapFirst})
        let indexOfObjectSecond = self.modelCells.index(where:{$0 == self.modelCellFromSwapSecond})
        
        let modelCellFirst = ModelCell(column: (self.modelCellFromSwapFirst?.column)!, row: (self.modelCellFromSwapFirst?.row)!, type: (self.modelCellFromSwapSecond?.type)!, click: (self.modelCellFromSwapFirst?.click)!)
        
        let modelCellSecond =  ModelCell(column: (self.modelCellFromSwapSecond?.column)!, row: (self.modelCellFromSwapSecond?.row)!, type: (self.modelCellFromSwapFirst?.type)!, click: (self.modelCellFromSwapSecond?.click)!)
        
        modelCellMathesForChecking[indexOfObjectFirst!] = modelCellFirst
        modelCellMathesForChecking[indexOfObjectSecond!] = modelCellSecond
        return modelCellMathesForChecking
    }
    
    private func getDataFromSwapModelCell() -> (rowFirst:Int,rowSecond:Int,columnFirst:Int,columnSecond:Int) {
        let rowFirst = self.modelCellFromSwapFirst?.row
        let rowSecond = self.modelCellFromSwapSecond?.row
        let columnFirst = self.modelCellFromSwapFirst?.column
        let columnSecond = self.modelCellFromSwapSecond?.column
        return (rowFirst!,rowSecond!,columnFirst!,columnSecond!)
    }
    
    private func playSound(isRightChoice:Bool){
        if isRightChoice {
            AudioPlayer.sharedInstance.setMusic(nameSound: Sounds.scrape, type: Sounds.Types.wav, loop: 0)
        }else{
            AudioPlayer.sharedInstance.setMusic(nameSound: Sounds.error, type: Sounds.Types.wav, loop: 0)
        }
    }
    
    private func swapModelCell(){
        self.setupPropertyForModelCellSwap()
        self.updateCell(notificationName: Notifications.notificationNameSwap,
                        object: self.modelCellFromSwapSecond)
        self.resetSwapModelCell()
    }
    
    private func setupPropertyForModelCellSwap(){
        let type = self.modelCellFromSwapFirst?.type
        self.modelCellFromSwapFirst?.type = (self.modelCellFromSwapSecond?.type)!
        self.modelCellFromSwapSecond?.type = type!
    }
    
    private func isStateModelCell()->Bool{
        if self.modelCellFromSwapFirst != nil && self.modelCellFromSwapSecond != nil {
            return true
        }
        return false
    }
}
