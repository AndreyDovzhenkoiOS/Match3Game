//
//  ModelCell.swift
//  Match3
//
//  Created by Andrey on 12.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ModelCell: NSObject {
    
    //MARK: - Property
    
    var column: Int
    var row: Int
    var type: Types
    var click: Bool
    
    //MARK: - Initialization
    
    init(column: Int,row: Int,type: Types,click: Bool) {
        self.column = column
        self.row = row
        self.type = type
        self.click = click
    }
}
