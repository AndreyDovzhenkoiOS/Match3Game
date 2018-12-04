//
//  ManagerGame.swift
//  Match3
//
//  Created by Andrey on 12.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ManagerGame: NSObject {
    static let sharedInstance = ManagerGame()
    
    //MARK: - Property
    
    var completionHandler = {(isTime:Bool,isRefresh:Bool)->Void in}
    var modelCells = [ModelCell]()
    
    var timeTimer:Timer?
    var time = 0
    var score = 0
    
    private var types = [Types.biscuit,Types.cake,Types.croissant,Types.danish,Types.donut,Types.star]
    
    //Setting in ManagerGame
    private var numberRows = 5
    private var numberColumns = 11
    private let increaseScore = 8
    
    //MARK: - Functions
    
    public func setupRowsAndColumns(width:CGFloat,height:CGFloat){
        self.numberColumns = Int((width)/50)
        self.numberRows = Int((height)/50)
    }
    
    public func startGame(){
        self.fillModelCell()
        self.startTimer()
        self.completionHandler(false,true)
    }
    
    public func fillModelCell(){
        self.reset()
        for row in 0..<self.numberRows {
            for column in 0..<self.numberColumns{
                let type = self.getRandomType()
                let modelCell = ModelCell(column: column, row: row,type:type, click: false)
                self.modelCells.append(modelCell)
            }
        }
    }
    
    public func startTimer(){
        self.timeTimer?.invalidate()
        self.timeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.time += 1
            self.completionHandler(true,false)
        })
    }
    
    public func stopTimer(){
        self.timeTimer?.invalidate()
        self.time = 0
    }
    
    //MARK:- DetectMatches
    
    public  func startDetectMatches(completion:@escaping()->Void){
        ManagerDetectMatches.sharedInstance.setupDetectMatches(modelCells: self.modelCells, numberRows: self.numberRows, numberColumns: self.numberColumns) { (modelCellMatches,numberModelCellMatch,isMatch) in
            ManagerImprovement.sharedInstance.resetChangeImprovement(isReset: isMatch)
            if isMatch{
                self.startReplaceModelCell(modelCellMatches: modelCellMatches, completion: {
                    self.hideAnimateCell(modelCellMatches: modelCellMatches, completion: {
                        self.setupScore(numberModelCellMatch: numberModelCellMatch)
                        completion()
                    })
                })
            }
        }
    }
    
    //MARK:- SwapModelCell
    
    public func startSwapModelCell(index:Int,completion:@escaping()->Void){
        if ManagerImprovement.sharedInstance.isChangeModelCellImprovement{
            ManagerImprovement.sharedInstance.changeModelCellImprovement(index: index)
        }else{
            ManagerSwapModelCell.sharedInstance.setupSwapModelCell(index: index, modelCells: self.modelCells) {
                ManagerImprovement.sharedInstance.sameModelCellHideImprovement(modelCell: self.modelCells[index])
            }
        }
        completion()
    }
    
    //MARK:- Improvement
    
    public func improvementAction(tag:Int){
        switch tag {
        case 0:
            ManagerImprovement.sharedInstance.isSameModelCellHideImprovement = true
        case 1:
            ManagerImprovement.sharedInstance.isScoringImprovement = true
        case 2:
            ManagerImprovement.sharedInstance.stopTimeTimer()
        case 3:
            ManagerImprovement.sharedInstance.refreshModelCell()
        case 4:
            ManagerImprovement.sharedInstance.isChangeModelCellImprovement = true
        default:
            print("")
        }
    }
    
    public func getImage(type:Types,isClick:Bool) -> UIImage {
        let nameImage = String(describing: type).firstUppercased
        if isClick {
            let nameImageClick = nameImage + "Click"
            return UIImage(named:nameImageClick)!
        }
        return UIImage(named:nameImage)!
    }
    
    public func getRandomType() -> Types{
        let randomCount = self.getRandomCount(count: self.types.count)
        let type = self.types[randomCount]
        return type
    }
    
    
    private func reset(){
        ManagerDetectMatches.sharedInstance.modelCellMatches.removeAll()
        ManagerSwapModelCell.sharedInstance.resetSwapModelCell()
        self.modelCells.removeAll()
    }
    
    private func startReplaceModelCell(modelCellMatches:[ModelCell],completion:@escaping()->Void){
        for modelCellMatch in modelCellMatches{
            self.replaceModelCell(modelCellMatch: modelCellMatch)
        }
        ManagerDetectMatches.sharedInstance.modelCellMatches.removeAll()
        completion()
    }
    
    private func replaceModelCell(modelCellMatch:ModelCell){
        let index = self.getIndexOfModelCell(modelCell: modelCellMatch)
        let currentModelCell = self.modelCells[index]
        let type = self.getRandomType()
        let modelCell = ModelCell(column: currentModelCell.column, row: currentModelCell.row, type: type, click: currentModelCell.click)
        self.modelCells[index] = modelCell
    }
    
    private func getRandomCount(count:Int)->Int{
        return Int(arc4random_uniform(UInt32(count)))
    }
    
    private func getIndexOfModelCell(modelCell:ModelCell)->Int{
        let indexOfModellCell = self.modelCells.index(where:{$0.row == modelCell.row && $0.column == modelCell.column})
        return indexOfModellCell!
    }
    
    private func hideAnimateCell(modelCellMatches:[ModelCell],completion:@escaping()->Void){
        for modelCellMatch in modelCellMatches {
            NotificationCenter.default.post(name: Notifications.notificationNameMatch, object: modelCellMatch)
        }
        completion()
    }
    
    private func setupScore(numberModelCellMatch:Int){
        self.score += (numberModelCellMatch * self.increaseScore)
        ManagerImprovement.sharedInstance.scoring(increaseScore: self.increaseScore)
    }
}
