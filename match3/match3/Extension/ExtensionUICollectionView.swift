//
//  ExtensionUICollectionView.swift
//  Match3
//
//  Created by Andrey on 22.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
extension UICollectionView {
  public func reloadWithoutAnimation(){
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.reloadData()
        CATransaction.commit()
    }
}
