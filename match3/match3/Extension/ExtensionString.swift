//
//  ExtensionString.swift
//  Match3
//
//  Created by Andrey on 13.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import Foundation
extension String {
   public var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
