//
//  ExtensionClass.swift
//  Match3
//
//  Created by Andrey on 31.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import Foundation
extension NSObject{
   public func updateCell(notificationName:Notification.Name,object:Any?){
        NotificationCenter.default.post(name: notificationName, object: object)
    }
}
