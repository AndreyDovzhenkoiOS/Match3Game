//
//  ManagerDetectMatches.swift
//  Match3
//
//  Created by Andrey on 13.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ManagerDetectMatches: NSObject {
    static let sharedInstance = ManagerDetectMatches()
    
    //MARK: - Property
    
    var modelCellMatches = [ModelCell]()
    
    private var modelCells = [ModelCell]()
    private var numberModelCellMatch:Int!
    private var numberRows:Int!
    private var numberColumns:Int!
    
    //MARK: - Functions
    
    public func setupDetectMatches(modelCells:[ModelCell],numberRows:Int,numberColumns:Int,completion:@escaping([ModelCell],Int,Bool)->Void){
        self.numberModelCellMatch = 0
        self.setProprerty(modelCells: modelCells, numberRows: numberRows, numberColumns: numberColumns)
        self.detectMatches {
            completion(self.modelCellMatches,self.numberModelCellMatch,self.getIsMatch())
        }
    }
    
    public func checkingMatch(modelCells:[ModelCell]) -> Bool {
        self.modelCells = modelCells
        self.detectMatches {}
        return self.getIsMatch()
    }
    
    private func getIsMatch()->Bool {
        let isEmptyModelCellMathes = self.modelCellMatches.count > 0
        return isEmptyModelCellMathes
    }
    
    private func setProprerty(modelCells:[ModelCell],numberRows:Int,numberColumns:Int){
        self.modelCells = modelCells
        self.numberRows = numberRows
        self.numberColumns = numberColumns
    }
    
    private func detectMatches(completion:@escaping()->Void){
        self.calculateDetectMathes(positionDetectMathes: .horizontal)
        self.calculateDetectMathes(positionDetectMathes: .vertical)
        completion()
    }
    
    private func calculateDetectMathes(positionDetectMathes:PositionDetectMatches){
        let calculationNumbers = self.getCalculationNumbers(positionDetectMathes: positionDetectMathes)
        
        for number in 0..<calculationNumbers.numbers {
            var changeableNumber = 0
            while changeableNumber < calculationNumbers.changeableNumbers-2{
                
                let modelCells = self.getCurrentModelCells(number: number, changeableNumber: changeableNumber, positionDetectMathes: positionDetectMathes)
                
                let stateCalculateMatches = self.getStateCalculateMatches(modelCells:modelCells)
                
                if stateCalculateMatches.isVictory {
                    self.addModelCellMatches(modelCells:modelCells)
                    AudioPlayer.sharedInstance.setMusic(nameSound: Sounds.victory, type: Sounds.Types.wav, loop: 0)
                }
                if stateCalculateMatches.isEnd{break}else{changeableNumber += 1}
                
                // Подсчет только  для  3-ех обьектов
                //if stateCalculateMatches.isVictory{indexColumn += 2}
            }
        }
    }
    
    private func getCalculationNumbers(positionDetectMathes:PositionDetectMatches)->(numbers:Int,changeableNumbers:Int){
        switch positionDetectMathes {
        case .horizontal:
            return (numbers:self.numberRows,changeableNumbers:self.numberColumns)
        case .vertical:
            return (numbers:self.numberColumns,changeableNumbers:self.numberRows)
        }
    }
    
    private  func getCurrentModelCells(number:Int,changeableNumber:Int,positionDetectMathes:PositionDetectMatches) -> [ModelCell?] {
        var currentModelCells = [ModelCell?]()
        for index in 0..<3 {
            var modelCellCurrent:ModelCell?
            switch positionDetectMathes{
            case .horizontal:
                modelCellCurrent = self.getModelCell(row: number, column: changeableNumber+index)
            case .vertical:
                modelCellCurrent = self.getModelCell(row: changeableNumber+index, column: number)
            }
            currentModelCells.append(modelCellCurrent)
        }
        return currentModelCells
    }
    
    private func getModelCell(row:Int,column:Int)->ModelCell? {
        let modelCells = self.modelCells.filter{$0.row == row && $0.column == column}
        if modelCells.count > 0 {
            return modelCells.first!
        }
        return nil
    }
    
    private func getStateCalculateMatches(modelCells:[ModelCell?])->(isVictory:Bool,isEnd:Bool){
        let isVictory = modelCells.filter{$0?.type == modelCells.first??.type}.count == modelCells.count
        let isEnd = modelCells.filter{$0 == nil}.count > 0
        return (isVictory,isEnd)
    }
    
    private func addModelCellMatches(modelCells:[ModelCell?]){
        self.numberModelCellMatch! += 1
        for modelCellMatch in modelCells {
            self.modelCellMatches.append(modelCellMatch!)
        }
    }
}
